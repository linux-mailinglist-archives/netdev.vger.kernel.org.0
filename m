Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845C06D5C0E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbjDDJgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjDDJgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73268BB
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680600952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JrK7X+ZSeWzhwHoptZKcD0UTYVFxdTQ49/qeTYb58rc=;
        b=NFSgqOOr3mfn7/LzXHsJwKmuLBmst+bR9v4ZkEDUwX2lZ+HUH/gCikNoFyDrCCc51eGAvS
        5eGyDKzazHOkXVGMhHo9TNTmkkfwhNVo73/bIeL8PcW5tB8AKXUflzMulE2AAMwO8O1OPv
        mr33jlmjzhYBCyqhhqf34M/f1vuW/f4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-7Mlpi0EaO6GrnjE0WYLZQw-1; Tue, 04 Apr 2023 05:35:51 -0400
X-MC-Unique: 7Mlpi0EaO6GrnjE0WYLZQw-1
Received: by mail-qk1-f199.google.com with SMTP id z187-20020a3765c4000000b007468706dfb7so14291480qkb.9
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 02:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680600951;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JrK7X+ZSeWzhwHoptZKcD0UTYVFxdTQ49/qeTYb58rc=;
        b=uYo7zuOF3IVTZAqmvNqHOp1Fgxc5Sv1/NukgA2ZzySDmb6x5ZF1GlChDXPKib74Rlm
         WJpWwA90xD3h2cBRK/60+dWySYk0asWbtm/8RvD9yIyVrEhK/NTU9uqRIbZCtkmUewif
         GH1l57DSi0gcuRYS7fu8NLes8cU7WfgAUxIvc7f8tHl7wy5v2I6/7G9P8i6Ry2qRm1Nf
         UPLp9iSpoacuKSqvJPDFmbjT+D0FPPqKVVfzRYAg50WB7SrO7OqXZo3ptC9DYVUwnUMH
         /XbYBp3oVI18wU4bQagwoEzMmP9m6vBojcz+X142ZfUSguOLF7JT0ALTJjWwwkFC64nw
         PQpA==
X-Gm-Message-State: AAQBX9cUKgM9drsjX96N/suf36Qm3KGD6e3vKzL8sEjH7PBwaT8rzXj4
        d83+DxPVzHPDbH1rDuTgMQCLOHUTOavLJAIZqKYIbMJ7KL2KI7SJ3DLC0vM0AgvBOEc9x+SOeXo
        QsYHKF+WiuK4oeEIn+Jf1Uem6
X-Received: by 2002:a05:6214:509e:b0:532:141d:3750 with SMTP id kk30-20020a056214509e00b00532141d3750mr2370623qvb.2.1680600950778;
        Tue, 04 Apr 2023 02:35:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y1v1EJgU1FzrDPQiwE0zgRZ3vymDkDUPEgHA8ooNdt0CflqXqghzFBFZo5H4SuQi+7JojOSg==
X-Received: by 2002:a05:6214:509e:b0:532:141d:3750 with SMTP id kk30-20020a056214509e00b00532141d3750mr2370611qvb.2.1680600950546;
        Tue, 04 Apr 2023 02:35:50 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id ne2-20020a056214424200b005dd8b9345c1sm3268562qvb.89.2023.04.04.02.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 02:35:50 -0700 (PDT)
Message-ID: <a5a8791742d1e77d324d91ea6030bc9647c61148.camel@redhat.com>
Subject: Re: [PATCH] [net] update xdp_statistics in docs
From:   Paolo Abeni <pabeni@redhat.com>
To:     nick black <dankamongmen@gmail.com>, netdev@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Date:   Tue, 04 Apr 2023 11:35:47 +0200
In-Reply-To: <20230402084120.3041477-1-dankamongmen@gmail.com>
References: <20230402084120.3041477-1-dankamongmen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-04-02 at 04:41 -0400, nick black wrote:
> Add the three fields from xdp_statistics that were
> missing in the AF_XDP documentation.
>=20
> Signed-off-by: nick black <dankamongmen@gmail.com>

I think this kind of changes are best suited for net-next, please set
the target tree accordingly in next submissions.

> ---
>  Documentation/networking/af_xdp.rst | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git Documentation/networking/af_xdp.rst Documentation/networking/a=
f_xdp.rst
> index 247c6c4127e9..a968de7e902c 100644
> --- Documentation/networking/af_xdp.rst
> +++ Documentation/networking/af_xdp.rst

There is something strange in your setup, the above should be:

--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst

The format you used confuses my scripts. I handled this one manually,
but please update your setup to stick to the standard layout.

Cheers,

Paolo

