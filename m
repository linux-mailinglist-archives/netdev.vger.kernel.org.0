Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0932A3E76
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfH3TgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:36:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41354 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfH3Tf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:35:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so4012896pgg.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FJowHpKGv7nCHoLEVLkWHTbiOBZw1S7cDpB8XtLumrw=;
        b=fn65hvcpicxhyEpyhZBXM5UE+OQld94AzbvcFhXqrGBDvVIgM79MYl5XU0Tm1vrijf
         OBOv5DYfq4YIVK5zDm4oX7mkKjTKwMGEgFvSitUvD+LxS5vnLyVGLmtQJDvUxXYwoiG8
         JFSpZsRf2/2NNg03Qbj8Ow7plF8D3trFdqtdQ6xbBDo/yvQutFf1HiimRoe+RMygDmTc
         bW6iH5Vqrju3awjc/2LT5QlbHA7IUXOlCc653m817vnmn/ovK2I2aYhIQjMwWa1he4ne
         LqVDfTmhHfBljbvJ6yUH9DvAODcjfzHlNdGhn5QNsEkLCsE/1vmKwZmVTSEoq6Lc6BST
         Y44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FJowHpKGv7nCHoLEVLkWHTbiOBZw1S7cDpB8XtLumrw=;
        b=hZIcj5qrWHrEIC1nxS7lvSteoeWNk3FHBbndA7hU5YyLEG2wcM/AvjTfcsQHlJrpQm
         K0Xa+viSjipRhqmBcw4DZ7j2ZB2qpH6xesMukgbsgvh4NmqgYryosIQr94TrSti74Va6
         o8EjlAGSmWC4Qx8kVZwBy3oGR2Lsvb8EGk8jB9U7gvu5GrLWfLdVL7TZfwL/GG5ODg96
         EfMeHvklJ9uEjm3Ov6q0l8kUA9CEDRY0PCMRhxYPZ5pi7lviqna+X13OZndlwULfWOwF
         h6Pj5SzTiu5QuAiLDIgzcb0CTxKzlVn8YYH9e5htpmWjYtn6XjmyOahawJ3rNRnyLDqZ
         oSKg==
X-Gm-Message-State: APjAAAVOKL2rkQ7LqtjtzeKl4jZdFl5HAywVuBUKb6tRSft/Ilyeklzg
        /oZLcN4SS9scbqgALPg8GEXCR81Jjz4=
X-Google-Smtp-Source: APXvYqxAh+qjrMpMMJ+rewesAtgBWPaauN0OM8tC26BfbVnsFGIZuuT0WqPUh/1X/m5624RJGMy96Q==
X-Received: by 2002:a62:5501:: with SMTP id j1mr19674863pfb.166.1567193758998;
        Fri, 30 Aug 2019 12:35:58 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id i124sm7266932pfe.61.2019.08.30.12.35.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 12:35:58 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 12/19] ionic: Add Rx filter and rx_mode ndo
 support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-13-snelson@pensando.io>
 <20190829160610.60563ca0@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <8fc45b3b-291c-cdab-326e-b5235874847e@pensando.io>
Date:   Fri, 30 Aug 2019 12:35:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829160610.60563ca0@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:06 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:13 -0700, Shannon Nelson wrote:
>> @@ -588,8 +866,26 @@ static int ionic_set_features(struct net_device *netdev,
>>   
>>   static int ionic_set_mac_address(struct net_device *netdev, void *sa)
>>   {
>> -	netdev_info(netdev, "%s: stubbed\n", __func__);
>> -	return 0;
>> +	struct sockaddr *addr = sa;
>> +	u8 *mac;
>> +
>> +	mac = (u8 *)addr->sa_data;
>> +	if (ether_addr_equal(netdev->dev_addr, mac))
>> +		return 0;
>> +
>> +	if (!is_valid_ether_addr(mac))
>> +		return -EADDRNOTAVAIL;
>> +
>> +	if (!is_zero_ether_addr(netdev->dev_addr)) {
>> +		netdev_info(netdev, "deleting mac addr %pM\n",
>> +			    netdev->dev_addr);
>> +		ionic_addr_del(netdev, netdev->dev_addr);
>> +	}
>> +
>> +	memcpy(netdev->dev_addr, mac, netdev->addr_len);
>> +	netdev_info(netdev, "updating mac addr %pM\n", mac);
>> +
>> +	return ionic_addr_add(netdev, mac);
>>   }
> Please use the eth_prepare_mac_addr_change() and
> eth_commit_mac_addr_change() helpers.

Oh, hadn't seen those before... sure.
sln

