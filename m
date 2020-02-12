Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57A115AC6E
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgBLPyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:54:23 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43591 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbgBLPyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 10:54:23 -0500
Received: by mail-wr1-f42.google.com with SMTP id r11so2962670wrq.10
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 07:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/rXOpsKkt10moU7lekEvTC0uEyocGlv1SxIocX3MWw=;
        b=UU9X7xwB/mvhwXjMGXQzeoEjVwmosJR6gEXgmMqBrkTXSMdBW/1JLNRMOGmTJcdqNA
         vfehW/cZrxTfvaDEutGU00EabogazDha41k/K6aMHxIp6C2BC7c59HMSsK7HQLZt0Upf
         syIn6/2I3eneVxOzdDGU7BCm9LxFBr63gOFWDTN0kDhKknE0//bW+fg76cxlaYp5Q0Tx
         MBuOwhpJ52qkyfzy9LS6G6FtZ2nENyDJ7t8A3Kzr05l6nZaN91LArSgtw42nf1KTPJ4O
         WEYXBI/1kPDggLZ3FzZfzSf/owwJeM0/ALKc/lLMFAw/Kr1WcNq5BNxnf8YXvJciVkIJ
         02Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F/rXOpsKkt10moU7lekEvTC0uEyocGlv1SxIocX3MWw=;
        b=JArJAfHRizTzaNH6uRMQ8kfu6VnFRGJk2G150uB+0FDoFClSfJsiPK0RamCamgJhFE
         NbjTi6dw4aMMKqys2dzDbpjRwfCkEp/cFWLIbwFeudez1Ut0WYOgia4yLzRHOfhI70Gg
         qWg6a+/WUk06jIED+dAEMndishc5YOls/nr9ISU0IqN6eyfBDoETp8uRchNUbA15kr85
         6T6EtD3uerC45iyLt/hWGxhxOeLm1Gl16Ce/XJLhDYk+/ehp2Oz0nwIuWRHIeUJ5LdXb
         LBovYZ7UKTxCWDW+7VS+EIppP5JRmh7JCt6gJHailma/DoQD8yCeKiSsfx2QY6jM4jTe
         tipQ==
X-Gm-Message-State: APjAAAUE263XAXrD5FrWxRlhutsCIflWchG4SIdlDUJi+tizEIZbbrtK
        3H2zucsInixcJvxkHx6me3+gtizCT3g=
X-Google-Smtp-Source: APXvYqxhutMki2hrv2T6Hbwj3HQr2MPNwTygBfs5eVoJ0epnVKd759VIZBITYw/s68q4sdNrLp+c5w==
X-Received: by 2002:a5d:498f:: with SMTP id r15mr15638015wrq.284.1581522860895;
        Wed, 12 Feb 2020 07:54:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:69db:fab1:ccba:51cb? ([2a01:e0a:410:bb00:69db:fab1:ccba:51cb])
        by smtp.gmail.com with ESMTPSA id v5sm1064711wrv.86.2020.02.12.07.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 07:54:20 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 net] net, ip6_tunnel: enhance tunnel locate with link
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
 <20200212083036.134761-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ce1f9fbe-a28a-d5c3-c792-ded028df52e5@6wind.com>
Date:   Wed, 12 Feb 2020 16:54:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200212083036.134761-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/02/2020 à 09:30, William Dauchy a écrit :
[snip]
> @@ -1848,6 +1870,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
>  	dev->type = ARPHRD_TUNNEL6;
>  	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
>  	dev->mtu = ETH_DATA_LEN - t_hlen;
> +	if (t->parms.link) {
> +		tdev = __dev_get_by_index(t->net, t->parms.link);
> +		if (tdev && tdev->mtu < dev->mtu)
> +			dev->mtu = tdev->mtu;
Hmm, I was expecting 'tdev->mtu - t_hlen'. Am I wrong?

In fact, something like this:
dev->mtu = ETH_DATA_LEN - t_hlen;
if (t->parms.link) {
	tdev = __dev_get_by_index(t->net, t->parms.link);
	if (tdev)
		dev->mtu = tdev->mtu - t_hlen;
}

With ipip:
$ ip l s eth1 mtu 2000
$ ip link add ipip1 type ipip remote 10.16.0.121 local 10.16.0.249 dev eth1
$ ip l
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2000 qdisc pfifo_fast state UP
mode DEFAULT group default qlen 1000
...
10: ipip1@eth1: <POINTOPOINT,NOARP> mtu 1980 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
