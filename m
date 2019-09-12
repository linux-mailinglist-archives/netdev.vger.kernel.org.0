Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54718B1427
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfILRyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:54:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38853 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfILRyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:54:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so16469030pfe.5
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 10:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fU94P9hwVGyhG8ICrisnAfDeINw9lHggTBZKjaGwp4M=;
        b=mon7n7py1ymEe/kHzdHl7vQdeMmp4tt1UkwgH9mB+9XfrGdcV8Alx7awVyqwFyv6hA
         mnXXobrFe+LBqVhGyB9APBeJPV9b6tw0jA1ZEEbO7B8zZvG1t977RGVfP5423dwo3+qk
         5Nt/eQ068MXvfs0xnKI/qoxqA3YTDZ9p07zTL6zz4SziaehufgEqlhI3d/VQr6D5cu/V
         AqodTJ+Xwn6ZF8ze+YhMFoN11dTAxSKw2Jqv5QxyhCyUg9mtHgkml1WD1RH8ykCyrCUB
         c6nadyxVxKlFwsOpsHY3As3eUZsAHWxyCGhF+EMWkPP0s2undNsxrJy6PruLOAUV78ow
         UXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fU94P9hwVGyhG8ICrisnAfDeINw9lHggTBZKjaGwp4M=;
        b=uMgoypVOJcPGYd9kugC3MtuYMh1b8AEgy9NdDVi4e2o5hXWQkahwglq45vadwx9ehH
         HaxYPdSrLS1jtnmNFvCdWBt7dPwmUhpzrvQOaS4EM+a+E3tpHIiUes4YQuydpvs3syd/
         kj3vKmjvT4dXqP/DafhRtTep671yzKm/db7e7xTnmU4EaA6yPrPv4rVd7hNHXQyTck6D
         d4D7dnCd8icLUUXW206fzY+BFRKokTIEkS2m7GXVLxMqdmUXOu5TiBI+3PzSrpi8PrL1
         jORZ7eEfpB+vi9i9iSU497TzXTo7V9CLYXjWggt8m7AnKlunPBJCeXzSKY1L3vcA995t
         QYUQ==
X-Gm-Message-State: APjAAAXgkt2jYwolTlyzVkaINRJuS3TaHAOP/53Q2y7P1RbJ124rGOsD
        aU1XOzXE1dNNCFGyYNcTZqCmJvEKmwQMrtAc
X-Google-Smtp-Source: APXvYqzXy64H/Klv1ecPnfnSaxipUAH/IWTQxFWZ238j8JeZTwU17ePi6h3Q3jSp081YMznW2xr1Nw==
X-Received: by 2002:a62:e216:: with SMTP id a22mr34828884pfi.249.1568310854411;
        Thu, 12 Sep 2019 10:54:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b185sm31875932pfg.14.2019.09.12.10.54.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 10:54:13 -0700 (PDT)
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
To:     Jonathan Tooker <jonathan@reliablehosting.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Michael Marley <michael@michaelmarley.com>, netdev@vger.kernel.org
References: <20190912110144.GS2879@gauss3.secunet.de>
 <9d94bd04-c6fa-d275-97bc-5d589304f038@reliablehosting.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <21ead3ce-25d8-8be8-d7e6-46450fcd38b8@pensando.io>
Date:   Thu, 12 Sep 2019 18:54:10 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9d94bd04-c6fa-d275-97bc-5d589304f038@reliablehosting.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 5:33 PM, Jonathan Tooker wrote:
> On 9/12/2019 6:01 AM, Steffen Klassert wrote:
>> The ixgbe driver currently does IPsec TX offloading
>> based on an existing secpath. However, the secpath
>> can also come from the RX side, in this case it is
>> misinterpreted for TX offload and the packets are
>> dropped with a "bad sa_idx" error. Fix this by using
>> the xfrm_offload() function to test for TX offload.
>>
> Does this patch also need to be ported to the ixgbevf driver? I can 
> replicate the bad sa_idx error using a VM that's using a VF & the 
> ixgebvf  driver.
>

Yes.
sln
