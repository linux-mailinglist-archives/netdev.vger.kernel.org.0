Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1CB692772
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbjBJTxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjBJTxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:53:37 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD03A90;
        Fri, 10 Feb 2023 11:53:36 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id u27so7475499ljo.12;
        Fri, 10 Feb 2023 11:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6vpHTSsq3RuT3ZTbVZIw1FmvwScMrvkNjzVV5l91taQ=;
        b=RTYrGbtU3etE5hJdPLvvyJrgFyHgxb3oOWgcnCkfYu6txjHu0fKfpcxJwSY1njE7vq
         IfO484zScE0QgNzcNYMRzUOL62TltnTBAhQs0+OrcEX8VFkJvW2JB7oMhdaaWbImMU1E
         5z8HqOdL3iPc9sIZjeHdB4lK3lDaMYdDyxSS46DfQY+vohkAXHadyW74yh7IfOK6HQ2U
         7BgP0jR7ZK4BzirqjoDZnx5tvmCsJWtUyCUgereqK17xZcIRG+e4SqKYX6gh+IBTMJq7
         sl4x09Cvs32E36mc1GGc2JTlmNAxrWOerqYAK1DtystlFaJ9g+5Qwaj8C07MxrCtXGlB
         ZXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6vpHTSsq3RuT3ZTbVZIw1FmvwScMrvkNjzVV5l91taQ=;
        b=VdZZwE23CS/uF90wjrbGAQYM1akysE5K5npiVmEVpXhVulMNhwKnbjiQKt3+mHoRiQ
         EoDWs57SC72RvwCWE/YLuJsJvKMQHgvxkgAOi7Tj4F5a5JLhqyDSepN6cZwwWZp/Dwd7
         pijV62aXFmfO/ChEUFQynwzijSnthRNk28/QTWdnFfFs0PBrjTdoEVvEAB1ojqUrArJ1
         ApZvMOGVQ5lzhCby8of4aC3Phw16x7yK2q1zCIhmE1FhOOqz80fwBqdpQS0TJMHa2NFR
         jeBu/p8c40rueRcNMJrD7+P/gxqJgH8Ub6pz+FWHVUCGlf5c95PX+YbwnqtahqlvzL4g
         oEYg==
X-Gm-Message-State: AO0yUKW4ye+NUI4h/Dzr0YuUzT5Gz2dUx7p/KvLU5Iz0twKtdu4bxLjb
        j064Ug6F+2BxNiSr7XtT0wborR7g/DRka7iabuI=
X-Google-Smtp-Source: AK7set9VxYinyOMzIxrzSekHnF65lzsk7aEnU8u6+pBnNfqPVN6bXPPXRIgcPLxBqkAhGhgebIawVIX3zk+f3YnIXU8=
X-Received: by 2002:a2e:a0c7:0:b0:28b:795c:51f8 with SMTP id
 f7-20020a2ea0c7000000b0028b795c51f8mr2722196ljm.98.1676058814784; Fri, 10 Feb
 2023 11:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20230210041030.865478-1-zyytlz.wz@163.com>
In-Reply-To: <20230210041030.865478-1-zyytlz.wz@163.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 10 Feb 2023 11:53:23 -0800
Message-ID: <CABBYNZL_gZ+kr_OEqjYgMmt+=91=jC88g310F-ScMC=kLh0xdw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Fix poential Use-after-Free bug in hci_remove_adv_monitor
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     marcel@holtmann.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

Hi Zheng,

On Thu, Feb 9, 2023 at 8:11 PM Zheng Wang <zyytlz.wz@163.com> wrote:
>
> In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
> the function will free the monitor and print its handle after that.
>
> Fix it by switch the order.
>
> Fixes: 7cf5c2978f23 ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  net/bluetooth/hci_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index b65c3aabcd53..db3352c60de6 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1980,9 +1980,9 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
>                 goto free_monitor;
>
>         case HCI_ADV_MONITOR_EXT_MSFT:
> -               status = msft_remove_monitor(hdev, monitor);
>                 bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
>                            hdev->name, monitor->handle, status);
> +               status = msft_remove_monitor(hdev, monitor);

I wonder if it is not a good idea to move the logging inside
msft_remove_monitor?

>                 break;
>         }
>
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
