Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E862602860
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJRJc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRJcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7411AD9B2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666085544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaKW7JItVWG74B7PETMZEtBdF29D+OzolxES8SYu2d4=;
        b=dcBIvVSAwIvDLZoDdQKySC7TlFI1PukAN5yNzL5KyvSDHDCh7o7thlaobxBBBqzpEcoOhz
        alNcAFJTPGwi73+Bnf+bHEGXhCflwMZBzBKAWuYier5Olhsl76s1p4/ck++hTvXfUMM96L
        n4tYXRnW1sicZuGtDFp2OZkhpEiIkxU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-6bk-QSgyMfi6Lae35BzImw-1; Tue, 18 Oct 2022 05:32:22 -0400
X-MC-Unique: 6bk-QSgyMfi6Lae35BzImw-1
Received: by mail-qk1-f197.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso11728225qkp.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jaKW7JItVWG74B7PETMZEtBdF29D+OzolxES8SYu2d4=;
        b=nXhWPelniklsyR7PccJg7ik31kRkK4Di4XxohZg2BbkObIde5Y90u/mD1KyqUVuVyT
         jZVkCg3xbOBnJ/JXkAHfhaPkzMiKk8UUPh6byi93Yi+fFVDtzWwJvtCElXuGfWhxmm/H
         7m7jnd8lAxR1kpLcgXHIGd9u41z3R+AF1pOX6CyuXTSyM7qaEeLJo9NLq9N2M5lkvLBg
         pRIYoAXuklgXtlqf63cCwPh1CpHno41QD6uKwyhe7LvbAzEtYyCKRlQUASUwMB3SG9Ii
         dn6p6r0jl3dtZaISdlynh/wiyFDRLT2LWPWGdR7E1BEtsCmP1Gx9O5TvTb0e+NDGR5f6
         HkZA==
X-Gm-Message-State: ACrzQf2XvUUKTJdFnDth+zEyZilBNfoFbGw4XKHg49bdxjQ3kPFfFpup
        0F7bDmZUgfBysZJ8XLySjM0zByYofSUMPZ6yguiPnBlMeZkOWKjAF4V1rKRgAGLE21lzkgu4wi8
        Anb5kWUlIr81bOyEN
X-Received: by 2002:a05:620a:12ec:b0:6ee:9e71:190 with SMTP id f12-20020a05620a12ec00b006ee9e710190mr1103864qkl.527.1666085541968;
        Tue, 18 Oct 2022 02:32:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HYALH6K/BuMv8cX8FiT1A5mCWx1MZ9cU1huHo5Z5EMc2/9Go5/9aTf64pCqKeYPgmRz6DWw==
X-Received: by 2002:a05:620a:12ec:b0:6ee:9e71:190 with SMTP id f12-20020a05620a12ec00b006ee9e710190mr1103851qkl.527.1666085541716;
        Tue, 18 Oct 2022 02:32:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id bq12-20020a05620a468c00b006ee957439f2sm1869653qkb.133.2022.10.18.02.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:32:21 -0700 (PDT)
Message-ID: <bb57c67a9235cb47d62a7cf8c01b70b8815b2d29.camel@redhat.com>
Subject: Re: [PATCH] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 18 Oct 2022 11:32:18 +0200
In-Reply-To: <20221017084408.18834-1-shangxiaojing@huawei.com>
References: <20221017084408.18834-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-10-17 at 16:44 +0800, Shang XiaoJing wrote:
> skb should be free in virtual_nci_send(), otherwise kmemleak will report
> memleak.
> 
> Steps for reproduction (simulated in qemu):
> 	cd tools/testing/selftests/nci
> 	make
> 	./nci_dev
> 
> BUG: memory leak
> unreferenced object 0xffff888107588000 (size 208):
>   comm "nci_dev", pid 206, jiffies 4294945376 (age 368.248s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000008d94c8fd>] __alloc_skb+0x1da/0x290
>     [<00000000278bc7f8>] nci_send_cmd+0xa3/0x350
>     [<0000000081256a22>] nci_reset_req+0x6b/0xa0
>     [<000000009e721112>] __nci_request+0x90/0x250
>     [<000000005d556e59>] nci_dev_up+0x217/0x5b0
>     [<00000000e618ce62>] nfc_dev_up+0x114/0x220
>     [<00000000981e226b>] nfc_genl_dev_up+0x94/0xe0
>     [<000000009bb03517>] genl_family_rcv_msg_doit.isra.14+0x228/0x2d0
>     [<00000000b7f8c101>] genl_rcv_msg+0x35c/0x640
>     [<00000000c94075ff>] netlink_rcv_skb+0x11e/0x350
>     [<00000000440cfb1e>] genl_rcv+0x24/0x40
>     [<0000000062593b40>] netlink_unicast+0x43f/0x640
>     [<000000001d0b13cc>] netlink_sendmsg+0x73a/0xbf0
>     [<000000003272487f>] __sys_sendto+0x324/0x370
>     [<00000000ef9f1747>] __x64_sys_sendto+0xdd/0x1b0
>     [<000000001e437841>] do_syscall_64+0x3f/0x90
> 
> Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/nfc/virtual_ncidev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> index f577449e4935..9f54a4e0eb51 100644
> --- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -64,6 +64,7 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  	send_buff = skb_copy(skb, GFP_KERNEL);
>  	mutex_unlock(&nci_mutex);
>  	wake_up_interruptible(&wq);
> +	consume_skb(skb);

Looking at the nci core, it seems to me that the send op takes full
ownership of the skb argument. That is, you need to additionally free
it even on error paths.

@Krzysztof: it looks like that the send() return value is always
ignored. Do you plan to use it at some point or could we change the
return type to void?

Thanks,

Paolo

