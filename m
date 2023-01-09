Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DC66328A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbjAIVOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbjAIVOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:14:00 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D2E25FD;
        Mon,  9 Jan 2023 13:11:58 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bt23so15018227lfb.5;
        Mon, 09 Jan 2023 13:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NKI+/xQWA7SbrtTO+8CzLU5bh5dwJN+z24fvwTgujQ8=;
        b=HXE78xFTBHbG6aTml/Qnb+MP2ASgAmNY+iow5VEBoZkKRJ6pXJhxazmkgtioFl7eAR
         Hd9+eOyLGnWke353lv5D2tXbaLJ9s1rs22Tollb9Bq7PwiMwPu2S++6raY69bsJwkXjP
         TQ5zNYQIRs3F5CEiGZXYc6KH9P9MDjSHSdSHVCqFirA7//heIVehu5aj4uHwT29FVcV3
         b5R+e2QKqBM891cIkR81EgMpRG+dTyPChbJilVXtc2Ra/RSkiQKjbkwyo6zj5oWwKMQ7
         J2NACwFiMpQV/IZYIu7zU6lpLtB+Mfg0GXKOaya0udqys70TJzLXyAznPO6qggchxynT
         L/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKI+/xQWA7SbrtTO+8CzLU5bh5dwJN+z24fvwTgujQ8=;
        b=E5xJXlf6aBagvXWhEF6FLO3IOhAa5sey6E469U1TrYPeWT99eYCa+RH9ckG6pK2GmG
         YEBVjDnWo7vU+IwbBxmXObFXdsguDOc1mf8WISvEQqij6BQgRUI2CT+al3mhb3qStNqW
         KmC1y84z3FTGbklitbNTWMrvkHUOykWQiN1+rMtkaJMRNc3vxnDlNwCPpt5KElIgjaOu
         OAi8+UxPNgvyRTFXxl3/u25Jq3e0GvyCe4vPQNosbnYbpFHJqIZeQZkwaq0FEqWVLNt5
         6rEiniuEpdYB//B5/729hLvNkdwrOgfONar1gh6niQ+o5FrDgNnVRXGZbO4thvaOwN31
         Bc6w==
X-Gm-Message-State: AFqh2krE1ucuqULv5uFoV/NGyzCyd5APUeYixif4t0fOWls2F1EaWjRu
        VrCr3YOt8JhuolVldrXc1PJm76rnJoSpSbG3PmM=
X-Google-Smtp-Source: AMrXdXuDqWNV4lk+aI5qjgknlUk6cMgYfrI9bFFWSJPbY0MCem9UD0SD/QzQNjDHSEbJYJ2SnZxtlDqPF58sy6qSCig=
X-Received: by 2002:ac2:597a:0:b0:4cb:22ab:ce08 with SMTP id
 h26-20020ac2597a000000b004cb22abce08mr1373247lfp.251.1673298717049; Mon, 09
 Jan 2023 13:11:57 -0800 (PST)
MIME-Version: 1.0
References: <20230109012651.3127529-1-shaozhengchao@huawei.com>
In-Reply-To: <20230109012651.3127529-1-shaozhengchao@huawei.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 9 Jan 2023 13:11:45 -0800
Message-ID: <CABBYNZK=GXHO3QrEF2ZXWohnYkyPsfo0K9ZPxe0aMK_wuK1myQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        brian.gix@intel.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhengchao,

On Sun, Jan 8, 2023 at 5:17 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> When hci_cmd_sync_queue() failed in hci_update_adv_data(), inst_ptr is
> not freed, which will cause memory leak. Add release process to error
> path.
>
> Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/bluetooth/hci_sync.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 9e2d7e4b850c..1485501bd72f 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -6197,10 +6197,15 @@ static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
>  int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
>  {
>         u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
> +       int ret;
>
>         if (!inst_ptr)
>                 return -ENOMEM;
>
>         *inst_ptr = instance;
> -       return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
> +       ret = hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
> +       if (ret)
> +               kfree(inst_ptr);
> +
> +       return ret;
>  }

While this is correct I do wonder why we haven't used ERR_PTR/PTR_ERR
like we did with the likes of abort_conn_sync, that way we don't have
to allocate anything which makes things a lot simpler.

> --
> 2.34.1
>


-- 
Luiz Augusto von Dentz
