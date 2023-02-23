Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EEE6A0617
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjBWKZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjBWKYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:24:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AC325B9F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:24:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j3so6433391wms.2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JUQmnkuOQQaJ2d5xE6ObfR37rARPPyZj6KZWGgxUgQ=;
        b=fGpEDc6DvifsWkJoIIici1IG89eNplW7743QoAW8lI47Yoy9tsUCqFYpWitY4M7knC
         YquI7b57o5crG3umfV2O8d6W8h/woA7MiDPnkLXW1HIl9j34MoixRXJBnN/O+nQ8YNe+
         dwoIG5KLiXnjdF4DokDAz20X4wQKbkWY3TTvT9AOpysQvnz9yG+nzKbCblt8KlBhHiog
         TBvg1vNFgci0Jk20rMV78QmGEEVZqcp7jG3MlXg3lPLqgfj8VxRyIBC0THWG9fnqs69y
         n6fkgLiZ8kdReF1gVQZ+KtjXSk8DOn17JCjnpkap9+4H2dAsUd/6HEAB6mkQ/BS83ilO
         g00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9JUQmnkuOQQaJ2d5xE6ObfR37rARPPyZj6KZWGgxUgQ=;
        b=QvSMmNoEmLK6keSueZ08QRQ9hmGb0/vrTfBe0C1LZQ1nAqTGiugvp2QKpGaetrTjJu
         HU24P1szPUdLj2Lj6u+m2++Lb62xVw7mh8Sfv+c7vesSIGx8ah9NUdeMJtf+bYbzK8cs
         LtSMF+gAhKE6tj/ce5iB+T86ETLrLJ/KcDUpKP4p348eWj91YXgRZTzDCeJDlhZUmYHy
         JHuTVXLOGypAYwszA2ljP0XL9dRt8xIrMD5P76ptWyw41C/fu00+T6T4XACIQq2DCecM
         QXSyaZn9NqeAX/Qf8pFTVEwHgdi3a92Cp20cACVwLefy2jupisK6wafuHCkmLwEUHgoV
         u5dg==
X-Gm-Message-State: AO0yUKVVy3n19Tz6OKadXRrN+G0gSRsutHk5RUMcyUBLTkrnjcAQzBAM
        9/YNYGizkLLJRWpsuYVxrIzsLNZZB4P8AJejE1AL/Q==
X-Google-Smtp-Source: AK7set+4pcCv2aMQJQTw7N75edIM+jkqSHB68JQHND0oJ0nwItRAtSIHjT9wPAATf+z5uZrjQUkfKbzMeO6OV9JW0do=
X-Received: by 2002:a05:600c:3b0e:b0:3df:97cf:4593 with SMTP id
 m14-20020a05600c3b0e00b003df97cf4593mr237860wms.6.1677147889564; Thu, 23 Feb
 2023 02:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20230217223620.28508-1-paulb@nvidia.com> <20230217223620.28508-4-paulb@nvidia.com>
In-Reply-To: <20230217223620.28508-4-paulb@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Feb 2023 11:24:37 +0100
Message-ID: <CANn89i+Jd6Cy5H0UWS3j+nucGu-e8HP1sqdfoGzS=vGEEGawMw@mail.gmail.com>
Subject: Re: [PATCH net-next v13 3/8] net/sched: flower: Move filter handle
 initialization earlier
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 11:36=E2=80=AFPM Paul Blakey <paulb@nvidia.com> wro=
te:
>
> To support miss to action during hardware offload the filter's
> handle is needed when setting up the actions (tcf_exts_init()),
> and before offloading.
>
> Move filter handle initialization earlier.
>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---

Error path is now potentially crashing because net pointer has not
been initialized.

I plan fixing this issue with the following:

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index e960a46b05205bb0bca7dc0d21531e4d6a3853e3..475fe222a85566639bac75fc4a9=
5bf649a10357d
100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2200,8 +2200,9 @@ static int fl_change(struct net *net, struct
sk_buff *in_skb,
                fnew->flags =3D nla_get_u32(tb[TCA_FLOWER_FLAGS]);

                if (!tc_flags_valid(fnew->flags)) {
+                       kfree(fnew);
                        err =3D -EINVAL;
-                       goto errout;
+                       goto errout_tb;
                }
        }

@@ -2226,8 +2227,10 @@ static int fl_change(struct net *net, struct
sk_buff *in_skb,
                }
                spin_unlock(&tp->lock);

-               if (err)
-                       goto errout;
+               if (err) {
+                       kfree(fnew);
+                       goto errout_tb;
+               }
        }
        fnew->handle =3D handle;

@@ -2337,7 +2340,6 @@ static int fl_change(struct net *net, struct
sk_buff *in_skb,
        fl_mask_put(head, fnew->mask);
 errout_idr:
        idr_remove(&head->handle_idr, fnew->handle);
-errout:
        __fl_put(fnew);
 errout_tb:
        kfree(tb);
