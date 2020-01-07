Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDA0132DE0
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgAGSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:00:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33793 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:00:51 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so252798pfc.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 10:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=A/bTyjHKAgSCdx29b3EHpF8cDC16OuyRNDBrNJfTYf4=;
        b=nF5ScH80ONInxUfOViNl7SCoHqyIoRmAq5y3e//bwdrkgGZ+W/2A7+zUZUKdE20bk5
         tFN2JWqx3pS3CsdWYwOCK8ns5N88cFkA9v0mTEfdT9h8cv2+zfeDs+C/RZKZyiLh0gwr
         8iJIoOJQzghJ6gUDIkdszlAU3zwdVhLVj+7ohsMDzoLUaZWFLgS5LoT44K/aNHBp5nVc
         OBybUWy3jp7lz+kEW64nm5eQHXZl9axoBvpGfovSF7tJG912+U9kS99BwuH76spOxH5q
         4npxnOFu50l9gUaIUBbIY5KCq4ltWhOBCB2anscqclCoYRFrM1wrU6qoUEr0tbVAZ4aE
         ugjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A/bTyjHKAgSCdx29b3EHpF8cDC16OuyRNDBrNJfTYf4=;
        b=eemdbybz+TlXT/AZ/MtjJGSuXf7tlufGrPekWu+7CsxzuUaDBt1QCKxYZeiI+EoMg8
         fmHvKBxqO47j7ZSzgn0UxlwZxEhZqA9t6NH73o2DK+bLzrjOwilYwHuD11wPqGxf9pY/
         5U31pUtmPNiLJVPANO2DfNcMVjQ7k7Qkkao9dIeCeRDmtUBJrLtBOT81ZtdfznSaZb1p
         K9elFtxBJBMUQXF8au61boxfKgxcP+jSweWrlYZdKeLw23Ra4nu3xDsee9w1xDPYhidg
         7F6oBFaBdW7+INlcF4alyCr8iYamBx/dqJGzsizvFvXZ/YnTIX4vtVQm+3++Byx9gwc2
         sSiQ==
X-Gm-Message-State: APjAAAWF/CzR5QcEIaDEoi6+MPWO4ldllAYFDw16uLXlrHFPm3RYSXit
        5/RTO1+a8/CP+Sa0H2GI+YtVcTAgt/s=
X-Google-Smtp-Source: APXvYqy3u6x9R8X0lC8o4m9rR3gFu7uzeyNdGApD3FTOXvtY/aEYSo5+FliNOzJ6SLm3mhfm0Qe++Q==
X-Received: by 2002:a63:31cf:: with SMTP id x198mr704636pgx.272.1578420050664;
        Tue, 07 Jan 2020 10:00:50 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j8sm165441pfe.182.2020.01.07.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:00:50 -0800 (PST)
Subject: Re: [PATCH v2 net-next 3/4] ionic: restrict received packets to mtu
 size
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200107034349.59268-1-snelson@pensando.io>
 <20200107034349.59268-4-snelson@pensando.io> <20200107130949.GA23819@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <112c6fd3-6565-e88a-dde5-520770d9f024@pensando.io>
Date:   Tue, 7 Jan 2020 10:00:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107130949.GA23819@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 5:09 AM, Andrew Lunn wrote:
> On Mon, Jan 06, 2020 at 07:43:48PM -0800, Shannon Nelson wrote:
>> Make sure the NIC drops packets that are larger than the
>> specified MTU.
>>
>> The front end of the NIC will accept packets larger than MTU and
>> will copy all the data it can to fill up the driver's posted
>> buffers - if the buffers are not long enough the packet will
>> then get dropped.  With the Rx SG buffers allocagted as full
>> pages, we are currently setting up more space than MTU size
>> available and end up receiving some packets that are larger
>> than MTU, up to the size of buffers posted.  To be sure the
>> NIC doesn't waste our time with oversized packets we need to
>> lie a little in the SG descriptor about how long is the last
>> SG element.
> Hi Shannon
>
> Does the stack really drop them later? With DSA, the frame has an
> additional header, making it longer than the MTU. Most of the NICs
> i've used are happy to receive such frames. So it does seem common
> practice to not implement a 'MRU' in the MAC.
>
> If the stack really does drop them, this is a reasonable optimisation.
>
> Thanks
>
> 	Andrew
Hi Andrew,

In my experience the driver typically tells the NIC about the current 
max_frame size (e.g. MTU + ETH_HLEN), the NIC only copies max_frame 
bytes, and the NIC returns an error indication on a packets that had 
more than max_frame.

Before this patch we were telling the Naples NIC of buffers that are 
longer than max_frame.  This NIC will happily accept oversized packets 
off of the wire and copy as much as it can into the buffers, and it will 
only set an error status when it runs out of buffer, not when it goes 
above max_frame size.  To get the "correct" behavior, we can't rely on 
setting max_frame, we have to rely on the buffer indications.

sln

