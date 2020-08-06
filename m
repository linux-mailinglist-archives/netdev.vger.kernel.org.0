Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC9B23DF2D
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgHFRjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbgHFRjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:39:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE31C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 10:39:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t6so7044031pjr.0
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 10:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RIZKUxvLSwn3mR0gtIrEk0Zm7rkst7TBKd8CApnNZ4Y=;
        b=WKgwQpHAGGPs+vIWpuD1T3PKV3T9bucVf332NFcvmd5pHVAJkBdWKHlh2X1D6koiCB
         m80vhLwurDCG8w/fdd9tGueYh0kv1CIb5sQIzUWTqeC5snAfHprEhC4zVhPYZeyqhqS7
         y+dSAOcK8l4g2SF+JJ2rCUvyivNOSLQjQaZbJzLSEDU/6RdVI6A7x6HpQqBgzQD/PaQ9
         zq/8icgyyILrYn+iZJjiZkkYE+Og0WyAJw3A7Y6KcqzLGfn1Lc3hHZyfwSjiw8VsNZmx
         dF/8r3D+fvT95vS2vmKERve3Z+VHeA/kdNIW7NPBbtKr7jgYj0X/frNofVhu3Rweg2B3
         OZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RIZKUxvLSwn3mR0gtIrEk0Zm7rkst7TBKd8CApnNZ4Y=;
        b=M8PPtY++P2ikn21CZhHPalthWZYfIpAx3ZgNOBRHq8ytaNNfEq+zB2feduMkOykT3s
         ENfD0q707yKgZoTfvq6JHXS3g4EYIAjHSZ0FG+QpbfrTEgpPjNBClbmWmx0maFokYekJ
         Doi2XRv5pfGe7ic50woqOHlIql2kfTjMgM53QhrjI//8s24DsKxN3M+RC+mxnM6VfxtB
         s4PfcfNY/yYskSXvLYTwXxVkS/eTM1aQU+dQIvFfCsSKAJiNEKbBqlQcfKzYN7LXhk23
         +pCTwuh535rUWT2Vw62K7g6+W+nc0+tbHx/M4rBqAkREcy1ImM03Yaqsd1w3XsZN5uia
         ftfg==
X-Gm-Message-State: AOAM530GZjBaLO8YgeaXmPXBGm4xuzKwu77eC39NM7QDGsjK2Lr/psAk
        nJxBTpqZR1n4bARCYAHwHBWvdGed
X-Google-Smtp-Source: ABdhPJyF0Cg9NC21d0bZu4N6hiMI5P1pWQvU20ZkIfoyxNcg41nx53X1+SLVH59R+iGXb652qlHB9g==
X-Received: by 2002:a17:90a:b292:: with SMTP id c18mr9490645pjr.207.1596735572124;
        Thu, 06 Aug 2020 10:39:32 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b185sm9073407pfg.71.2020.08.06.10.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 10:39:31 -0700 (PDT)
Subject: Re: [PATCH v2] net: add support for threaded NAPI polling
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
References: <20200806095558.82780-1-nbd@nbd.name>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bf4476c8-e67c-f398-c8b2-cb8d03dc5429@gmail.com>
Date:   Thu, 6 Aug 2020 10:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806095558.82780-1-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/20 2:55 AM, Felix Fietkau wrote:
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
> 
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
> 
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
> 
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).
> 
> Based on a patch by Hillf Danton
> 
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

...

> index e353b822bb15..99233e86f4c5 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -471,6 +471,47 @@ static ssize_t proto_down_store(struct device *dev,
>  }
>  NETDEVICE_SHOW_RW(proto_down, fmt_dec);
>  


This belongs to a separate patch, with correct attribution.

> +static int change_napi_threaded(struct net_device *dev, unsigned long val)
> +{
> +	struct napi_struct *napi;
> +
> +	if (list_empty(&dev->napi_list))
> +		return -EOPNOTSUPP;
> +	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +		if (val)
> +			set_bit(NAPI_STATE_THREADED, &napi->state);
> +		else
> +			clear_bit(NAPI_STATE_THREADED, &napi->state);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t napi_threaded_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	return netdev_store(dev, attr, buf, len, change_napi_threaded);
> +}
> +
> +static ssize_t napi_threaded_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	struct net_device *netdev = to_net_dev(dev);
> +	struct napi_struct *napi;
> +	bool enabled = false;
> +


You probably want to use RTNL protection, list could change under us otherwise.

The write side part is protected already in netdev_store()


> +	list_for_each_entry(napi, &netdev->napi_list, dev_list) {
> +		if (test_bit(NAPI_STATE_THREADED, &napi->state))
> +			enabled = true;
> +	}
> +
> +	return sprintf(buf, fmt_dec, enabled);
> +}
> +DEVICE_ATTR_RW(napi_threaded);
> +
>  static ssize_t phys_port_id_show(struct device *dev,
>  				 struct device_attribute *attr, char *buf)
>  {
> @@ -563,6 +604,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
>  	&dev_attr_tx_queue_len.attr,
>  	&dev_attr_gro_flush_timeout.attr,
>  	&dev_attr_napi_defer_hard_irqs.attr,
> +	&dev_attr_napi_threaded.attr,
>  	&dev_attr_phys_port_id.attr,
>  	&dev_attr_phys_port_name.attr,
>  	&dev_attr_phys_switch_id.attr,
> 
