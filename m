Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE085363DE
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353042AbiE0ONV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 10:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352175AbiE0ONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 10:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 621123A5CA
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 07:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653660796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BAlAIApVmZOxbOhn112/UH1a9dYigVoC4mhWeDYrpI=;
        b=HE2+2xB0kb4bffPzhlaABASkCxdbqA5QrY+g4A6W/40iefBVIkpq4bWMG16d1eMfr43XJG
        jeGcdYClJQ24tDfMIVeKeMLoZBUc6Q4Mn1Vyogu6zrefNRjyV7NtE2QF6LZbpy/XBg/QJ1
        pI9OHFWMac/ouy1+qP9bR7Nuwb8usOI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-jp-CTBE8OYiCIUPjN6CX3w-1; Fri, 27 May 2022 10:13:12 -0400
X-MC-Unique: jp-CTBE8OYiCIUPjN6CX3w-1
Received: by mail-qt1-f198.google.com with SMTP id u17-20020a05622a199100b002fbc827c739so4532672qtc.8
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 07:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5BAlAIApVmZOxbOhn112/UH1a9dYigVoC4mhWeDYrpI=;
        b=n+E1JeTgfqZPCx0D0HdBQiGUteQSWBJtim9nW2rb7qqDTBaos+au7gg0+ZGihzOvb/
         VLbsZOFTWzZdKsl+fjMrvjm58v+/AfeEKJDHN+oB29Gt4YAgy0BF6l7Yd7vQJT6xpV3c
         aFn2FV6F79mqjR8SGtLtcve6H2oU0bVZiQffmWhZ7QRv5qnuVVu7e+ZUbQgzL8+dOxqs
         45F2xb2gkOOPJn569xZpkIRQXuHwt+5Vp6X7H4C+DJM3mHMAJ/m4v6FQDPsXc70EjQi2
         T0mvZPcHgUHw5zyw68EW2/Shxf8GKZ2vbHm1SnH2LbBnANLeW59rXz++5m28jQJ9Da9n
         7B+g==
X-Gm-Message-State: AOAM5305+ecOthMN9c1kQpoaAPWiU8uxM7Bp8NTn7ut7poON9vG0m3xk
        ywUfpDhuxi/tug6LZY70/t953C73CPfirQpGldmoKlfGCEqhcoeJ3KZC/ogkYe2kl+ePYXLEZVp
        ia5LyGCye2zqAIFXC
X-Received: by 2002:a05:622a:104e:b0:2f3:f7a5:62e6 with SMTP id f14-20020a05622a104e00b002f3f7a562e6mr33219621qte.582.1653660791546;
        Fri, 27 May 2022 07:13:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfn20lDZZm/Jj52FTt2Gpxp0bbNdhr/JqiYMEq3qG4cMJUFZPYVLf0nFbAa7JJtTtpTNc79Q==
X-Received: by 2002:a05:622a:104e:b0:2f3:f7a5:62e6 with SMTP id f14-20020a05622a104e00b002f3f7a562e6mr33219582qte.582.1653660791213;
        Fri, 27 May 2022 07:13:11 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id c13-20020a05622a024d00b002f942e6bd88sm2747242qtx.48.2022.05.27.07.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 07:13:10 -0700 (PDT)
Message-ID: <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com>
Date:   Fri, 27 May 2022 10:13:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] bonding: show NS IPv6 targets in proc master info
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
References: <20220527064419.1837522-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220527064419.1837522-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/22 02:44, Hangbin Liu wrote:
> When adding bond new parameter ns_targets. I forgot to print this
> in bond master proc info. After updating, the bond master info will looks
                                                                look ---^
> like:
> 
> ARP IP target/s (n.n.n.n form): 192.168.1.254
> NS IPv6 target/s (XX::XX form): 2022::1, 2022::2
> 
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Reported-by: Li Liang <liali@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   drivers/net/bonding/bond_procfs.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
> index cfe37be42be4..b6c012270e2e 100644
> --- a/drivers/net/bonding/bond_procfs.c
> +++ b/drivers/net/bonding/bond_procfs.c
> @@ -129,6 +129,19 @@ static void bond_info_show_master(struct seq_file *seq)
>   			printed = 1;
>   		}
>   		seq_printf(seq, "\n");

Does this need to be guarded by "#if IS_ENABLED(CONFIG_IPV6)"?
> +
> +		printed = 0;
> +		seq_printf(seq, "NS IPv6 target/s (xx::xx form):");
> +
> +		for (i = 0; (i < BOND_MAX_NS_TARGETS); i++) {
> +			if (ipv6_addr_any(&bond->params.ns_targets[i]))
> +				break;
> +			if (printed)
> +				seq_printf(seq, ",");
> +			seq_printf(seq, " %pI6c", &bond->params.ns_targets[i]);
> +			printed = 1;
> +		}
> +		seq_printf(seq, "\n");
>   	}
>   
>   	if (BOND_MODE(bond) == BOND_MODE_8023AD) {

