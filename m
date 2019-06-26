Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1561C56E1A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZPyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:54:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46149 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZPyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:54:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so1566120pfy.13
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eZpWHGmWn5r17X7XPRThpw5E0O+MqhXek9Hw0KLquWw=;
        b=AaTSX/q/XrzowjvP4ac8e7PJ2D0zRYxGoywGMegdADSRqxzZGs9Y9FICzl2z1h5MBK
         7IcjVtcqB3MDZEnfj8J7DD+CjP7AezhypzCH85bH6Y8cF0ysFJMANyPkWMiIl5GuJARx
         Q6RnNUaL9MtOEVR/4+SijYoNL/x00Q4gyOG6c4MX7ZrVyobsQUeAznv1bFh34LofIaYP
         T3ZCdEZlLehnGSejhORBLd/7lH2tlXbhPZYm5t13oLOJQ3alcOmELqWwpstCg2srC9Mk
         8ocmbTe28PG7BITBgKMwveMKm39PaHij8Bum7fCpDeiUu8ItJYq+FGaWyz1x5ce89TNm
         rQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eZpWHGmWn5r17X7XPRThpw5E0O+MqhXek9Hw0KLquWw=;
        b=qhYoysTOHc7uZ6Vo67BD/bcNdpy6wL62GidcxSqKX1/lACNEl+4R8h2cD6u4ZUPVkD
         TdbnV/32TnS+YZlJ4gLd0/QXyXqNk4NSpJwPVMIGgKAX2nKLZEZOPM8Hl050QNgYtu33
         nsbDVRH4mDR0ccVcJ00voVheg3hkS8jViYagRotcZRcm37+rGg8pMXmedcYhbYcqUMMX
         4ST88GKtHLn4+ZwicE3GOtMqrRqiaPEgB3Mgs1IqYjLkmSIT9u89GkYBi5SY9xcP0RLM
         EEloVh8C7ZO5dGZJLFzqAvTnNSw8WKBmlXJoptfEV9Q0DfZpJuOIROXmk4cCcBpBxNk3
         y7Qw==
X-Gm-Message-State: APjAAAU3xgDOzPsdY7wAbma8Q3YpqTDOiL9elWo3uEK8BwZp4503QZJO
        5hXsfacjGSqrfEFz1vLYh9Bqf468fYA=
X-Google-Smtp-Source: APXvYqzQjMtg/cPQu8MMKc86UdwXV8u4sLhMWhaNZNVFOIB3VqM/QIrbDxwSy9xJNK84xcqdtmbvYA==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr5525738pjb.137.1561564453674;
        Wed, 26 Jun 2019 08:54:13 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t7sm1032262pjq.15.2019.06.26.08.54.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:54:13 -0700 (PDT)
Subject: Re: [PATCH net-next 12/18] ionic: Add async link status check and
 basic stats
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-13-snelson@pensando.io>
 <20190625164713.00ecc9aa@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4804434c-166e-8829-972b-a245da3d987f@pensando.io>
Date:   Wed, 26 Jun 2019 08:54:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625164713.00ecc9aa@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:47 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:18 -0700, Shannon Nelson wrote:
>> +	/* filter out the no-change cases */
>> +	if ((link_up && netif_carrier_ok(netdev)) ||
>> +	    (!link_up && !netif_carrier_ok(netdev)))
> nit: these are both bools, you can compare them:
>
> 	if (link_up == netif_carrier_ok(netdev))
>
>> +		return;

Yep - thanks.
sln
