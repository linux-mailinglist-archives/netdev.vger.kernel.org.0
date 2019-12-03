Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC4110575
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfLCTrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:47:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34809 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfLCTrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:47:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id h13so2108522plr.1
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 11:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VZy3b2sJqOPadE7gaKlbeJchIAlYOyJ+QAzM+KPmmFA=;
        b=WMyT/GO0Y2I2VLICpbCCKvAvQMKRe2JwdmPtPAr8Ow1tNeMvGbkLwOK/7qRLLO3PsF
         xZJKprAjMbYkYEgjBNN81NavUXlKsKpplItcFzJqG49u1Ngr2VLxpZNHZGzGsCRpCuDn
         z9NRV4SIYJ7fziD05cu6ZZddWs8d64FsPo+8dWDS4TRW6PW81NB9EFHXRjXEnOEiwLk+
         lMGcPCRT3iJHiYiwgwMVFBjkX4s0f8w+P4UeqeOuMBBMnhwo2TR790uq/7G4aC4fu68e
         DYnjsrzP/mhK3lThAQJmNkLh/YMVU8/XubH4JXk69xD69JyJbhNd8qY3D/h8Z5+INXGO
         jTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VZy3b2sJqOPadE7gaKlbeJchIAlYOyJ+QAzM+KPmmFA=;
        b=eeUS+US/6e3BK/eQjEpaimLMTXRFV8+3QTuMWjwCrP9z320qMULwHk2yUIU3FPEFIJ
         d99z+Q2mFpqvGooahfxjoF4uw+hRofXvsdAz0vBLlVNg7dLsTVH8lQBtaW/rz7D1IG81
         oP9fCYs4Se+kXD53a0qrBmgkKBMwmY3aQZ0MBiYCTGnmWpFDEEPld1sAXVRM2xaDnn07
         h3NOTzlZFOqaJ0DNehLL9/ij8Xltkti8nxBhTYbNY9wtmEXWnsYpmRd6mEnicD6On9Dt
         NoGVU95eARTDz1mJElwf2SYAo3gr9zKNOtWk2hZCcuzEllkGMJeASLJ31BUVb0wsEDjd
         RKzg==
X-Gm-Message-State: APjAAAVs8CqnzvXpbn5T2anHTuA4zumFMs+PRmdB7SkJdUM5oB7qfw8h
        wG9lepUlHIlE74LnJx8oOImIag==
X-Google-Smtp-Source: APXvYqyrvjU6wkrEA/C/p5ZheQAoQCPpcKcpzT0BUAICvdAJleVDkG2lQAWcglDPjqG3XnzSUfJBPw==
X-Received: by 2002:a17:90a:2201:: with SMTP id c1mr7247627pje.31.1575402466612;
        Tue, 03 Dec 2019 11:47:46 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id h7sm5293581pfq.36.2019.12.03.11.47.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 11:47:45 -0800 (PST)
Subject: Re: [PATCH RFC v7 net-next] netdev: pass the stuck queue to the
 timeout handler
To:     "Michael S. Tsirkin" <mst@redhat.com>, jcfaracco@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
References: <20191203071101.427592-1-mst@redhat.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <80070eaa-84b2-5f41-db72-d8bf594924fd@pensando.io>
Date:   Tue, 3 Dec 2019 11:47:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191203071101.427592-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/19 11:12 PM, Michael S. Tsirkin wrote:
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
>
[...]
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 20faa8d24c9f..f7beb1b9e9d6 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1268,7 +1268,7 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
>   	rtnl_unlock();
>   }
>   
> -static void ionic_tx_timeout(struct net_device *netdev)
> +static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>   {
>   	struct ionic_lif *lif = netdev_priv(netdev);
>   
>
[...]


For drivers/net/ethernet/pensando/ionic:
Acked-by: Shannon Nelson <snelson@pensando.io>


