Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD152A0E6D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfH1XrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:47:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40875 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1XrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:47:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so777526pfn.7
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vu0+3yHfkDTrUpmZyQTt4ECZH8qi0e3c0manwe13wiY=;
        b=PkHEy0HwW2BalcfylGt8dY7/RfDxUjBxxcUaOg2Qgo6o6zdk6ZMNhk8NK1DZMIrG9y
         bv8NmWuNOJyLE9Mq7G/iENYmMFur8xaUNAjcIjQSWo0VLAJBTxE1hXLMZUTdxC3307gf
         EXjBbRFNfl7VuPPUT/n2T/PwfIROYEf8ydeA/d+sxFlXBxWXR0JLBNUL7UcXh+9+3Twc
         PfEVhxsRxH9fqO8nzJeMo1vWkAcnjTmCKCFCer8iGIunHC2DUc6EyXeTam/w7876PoS+
         vtd2d2zPoHmr8HRcMyDgpaejDaSGuPkT14nsugevTVct1Cor3zV9bdWSGlYjBngjZBdO
         yUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vu0+3yHfkDTrUpmZyQTt4ECZH8qi0e3c0manwe13wiY=;
        b=UqGDqd3/qWuFC0bHIZcoUXIRGlzj/ngGtNgj5zkWJWTeCWHoECSpD90k+uCjOd0Jy/
         rP3fG5vDyddu2jjngJcLAqFauRV2WrZB2thBfbHn5H8BVGq4Ma61uj0pIo0bXAUXh3PF
         0s9r4vMTyrvkL1CZgUCc5EObCLB6hbvhMsrGv/zCptMYoa3BEGCgU4TcculFEQd/YOs4
         ynrRqhFDq+oJSl4Z0NxHsnYQjkIpBH1nuMS6kZ54o06m918+HmekYApwXySDIf5Wj3py
         LakbEgG4n8dJOO17ILj6kurJ8KLULHJAOZxZneBC3F7F1o4gHzRI21KJEc8e7SwetCg8
         Y7Kg==
X-Gm-Message-State: APjAAAU2Ykl9bcX+iU5q23k7R182dKButXxExljsGQM8T1lY94VQxHro
        nU3F82sYScGOZKfXZRO0Gjw=
X-Google-Smtp-Source: APXvYqwwuMjDHxQXzEF119YgZ9fFFu2ZMsFqi4fmbZMbmWv1AhRaoFshMJkwFMVQq0q0fBeDL8oOiQ==
X-Received: by 2002:a63:b60b:: with SMTP id j11mr5523653pgf.283.1567036033893;
        Wed, 28 Aug 2019 16:47:13 -0700 (PDT)
Received: from [192.168.0.16] (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id j11sm504690pfa.113.2019.08.28.16.47.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 16:47:13 -0700 (PDT)
Subject: Re: [PATCH V3 net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, joe@wand.net.nz
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
 <20190828.145409.412910250799244993.davem@davemloft.net>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <79ebb0ba-2b7d-edd0-0cd7-0940441f9db4@gmail.com>
Date:   Wed, 28 Aug 2019 16:47:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828.145409.412910250799244993.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/2019 2:54 PM, David Miller wrote:
> From: Greg Rose <gvrose8192@gmail.com>
> Date: Tue, 27 Aug 2019 07:58:09 -0700
>
>> When IP fragments are reassembled before being sent to conntrack, the
>> key from the last fragment is used.  Unless there are reordering
>> issues, the last fragment received will not contain the L4 ports, so the
>> key for the reassembled datagram won't contain them.  This patch updates
>> the key once we have a reassembled datagram.
>>
>> The handle_fragments() function works on L3 headers so we pull the L3/L4
>> flow key update code from key_extract into a new function
>> 'key_extract_l3l4'.  Then we add a another new function
>> ovs_flow_key_update_l3l4() and export it so that it is accessible by
>> handle_fragments() for conntrack packet reassembly.
>>
>> Co-authored by: Justin Pettit <jpettit@ovn.org>
>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
> Applied with Co-authored-by fixed.
Thanks for fixing that up Dave.

- Greg
