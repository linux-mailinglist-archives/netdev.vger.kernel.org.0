Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC165627D5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfGHSBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:01:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46522 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbfGHSBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 14:01:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id z23so17086339ote.13;
        Mon, 08 Jul 2019 11:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JMLSGXlT3iSJpmRh2GfhH2MTdPzvNG/RLBCIaq7q1DE=;
        b=NhkzIgYsc+jkVgoi0AEKjTLWDp+VadO9nPKXg2stTXuCL5wne3ibdTnsCCoNlzYecT
         EISOiMD2fCqGI6QyjXvVkJ+BRtsSx2RW6uh2C/pvy5TPfIxII7Ng3wENwYJPnCFCI6tf
         C0NJBed6hhRtVOn22MySx/ZZY4U/AZef11ywmDZ5ePGxk4vAFWx/UlXJbfWJx8kTPGvH
         Qj9l8M0JetjAL+fcnEQT6NhU3RCGwI+MKJqEXo603rvT4jUisT1rnxjn8at1P7QdJu/Q
         +1oCZqiZH7yDdJK6PTdI+8qQbItEABdlrShXfNPaMmxcrI84ew/w6owmZAUEGCxtb/e3
         wsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JMLSGXlT3iSJpmRh2GfhH2MTdPzvNG/RLBCIaq7q1DE=;
        b=V/3UealP2QuBuDLAvoSvj/BfSkzyqfowfzEDhJx4pWT/vmhI1VnxizdiwU7ize2f3b
         xd5rUrrluuxSC4S26p0fDKEgUGOctAfy6jP+C2JdPjf2wim2OvejTNjJsAwJLKXfSNiQ
         J+hG+7yTRfKI/NP5h303+unxHyZMpgz9mGuB7qwEPZYQM+Icb1XOu7kzQkYXt/QZxlG4
         I892Tjx9xSNSurcrfrYd9kzauqqzitQ/UByoHlwvJS288bNvsOfUPvLVLh+YOZeRXGF9
         HkWhXhyxRYrkq6ykFAiImBATvqH2oRPpW6ZzvsN53GJBazJiV1gnyfu+1zgmcQ8ThYtN
         RWkA==
X-Gm-Message-State: APjAAAW/uERfS1EWhPRuQGp5MgZT/8qrJmq6kbnwZa49IiJfdj7iFgHZ
        f3JDSv0caEDbrOH86aki158220kK
X-Google-Smtp-Source: APXvYqz3Y0Vo9g1LDItsxpblqPdB8IwklWfZ2sznAXdTgLFhHNqdDhyzwRq3ICdJzzXTxdqlIdOMUA==
X-Received: by 2002:a9d:6b89:: with SMTP id b9mr1579766otq.322.1562608868717;
        Mon, 08 Jul 2019 11:01:08 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id f17sm127906otl.25.2019.07.08.11.01.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 11:01:07 -0700 (PDT)
Subject: Re: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>, stable@vger.kernel.org
References: <20190708063252.4756-1-jian-hong@endlessm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <212a37b0-583b-1062-64fd-f0fb0d4f982f@lwfinger.net>
Date:   Mon, 8 Jul 2019 13:01:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708063252.4756-1-jian-hong@endlessm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 1:32 AM, Jian-Hong Pan wrote:
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index cfe05ba7280d..1bfc99ae6b84 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -786,6 +786,15 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
>   		rx_desc = skb->data;
>   		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
>   
> +		/* discard current skb if the new skb cannot be allocated as a
> +		 * new one in rx ring later
> +		 * */
> +		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> +		if (WARN(!new, "rx routine starvation\n")) {
> +			new = skb;
> +			goto next_rp;

This should probably be a WARN_ONCE() rather than WARN(), otherwise the logs 
will be flooded once this condition triggers.

Larry
