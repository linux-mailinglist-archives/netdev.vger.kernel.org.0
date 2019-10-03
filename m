Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44ECBC96C4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 04:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfJCCmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 22:42:45 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34349 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfJCCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 22:42:45 -0400
Received: by mail-io1-f65.google.com with SMTP id q1so2129259ion.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9Hc25c1CIJ8bV6Dfe+zt6ovN8RaKMdn58fNYcXa+Kc=;
        b=GgjCe+UJzGIGxKFSSpNz7erd5Ep6zFfB51BD9QieafK/oV8KPlhO5LmgNseEvxtHbR
         FKikjJpemBsQhybQ4IXWxz8N4WbEENdQLRukVtVc2RVVg32ZQLcyWtZhh8nrnxCU54jd
         T+H1MyjrHmR0QYelONMrL8uQF7/O0Zds8Ke3RO7+Xq5hIzcFMoIKNYcIhktDxng0zVX+
         6ZSoVpYKze7OVTSmk31jRLBEp74Wv4xDQ2TxQmdQSeOOZe/UquROOL9zAVKtkUE7v2fQ
         Pvgt8bHiGKubpaoF3FOv8AJ5UGs5PKMEWuWAE/H5zDkF9E7eqXvob2nDmzChfgS0AFfd
         yxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9Hc25c1CIJ8bV6Dfe+zt6ovN8RaKMdn58fNYcXa+Kc=;
        b=Kbair0rs+OOkRmb+kNRiYkbN47iQUM+WAmqoel9mQEbLx0MdUM9gG8Gxp1/PfMptfd
         K5Jhnvf777ASeN94USvwE2+2h3oEZoKcA/Lh7wMrEaFMwsfG619N5A27Lrx+HbbQ8lyY
         +SoSwokEbyNvRmN6Zbv7zwddauXYaIyvlorsjjKEHbc6lS/0zT498461bv1OXYMj2D0Q
         eZge2Y1+t8dfp47B6sspEvavBRbDWQJ46Qqfx8itL5ZVITfdmmqpKe8OdfNNqj4EEl9g
         0vK8HFLQDQfxti6gHfJs0+2uEsejzcGdYvtzcHqT8LIUwPTOp87QiK+8FViGiGlCHhHU
         84RQ==
X-Gm-Message-State: APjAAAVpBJgLF/+1GNV+6UNpnXOw3OyWUDtA0l4UeQCFBaN9FEou97uf
        Lhx43jx6aZlN/42Zpk7hKAs=
X-Google-Smtp-Source: APXvYqxcZZKF4pa5WfzDx51b/dACwNj5VLxcIm4nq8P+ZAuKFVkVn2TUqCtYZsEuWXR4W3IBELAf+g==
X-Received: by 2002:a6b:b213:: with SMTP id b19mr5998203iof.58.1570070563167;
        Wed, 02 Oct 2019 19:42:43 -0700 (PDT)
Received: from [10.230.159.14] ([73.95.134.170])
        by smtp.googlemail.com with ESMTPSA id u124sm535423ioe.63.2019.10.02.19.42.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 19:42:42 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <erdnetdev@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
 <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
 <6b74af81-d12d-6abd-fd4f-5c1e758fdde7@gmail.com>
 <f896d905-9f69-465f-23c0-7e9a6014d990@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a2a936a-9b20-be61-2301-dfe83e41e605@gmail.com>
Date:   Wed, 2 Oct 2019 20:42:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f896d905-9f69-465f-23c0-7e9a6014d990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 6:36 PM, Eric Dumazet wrote:
> 
> 
> On 10/2/19 5:10 PM, David Ahern wrote:
>> On 10/2/19 4:36 PM, Eric Dumazet wrote:
>>> This might be related to a use of a bonding device, with a mlx4 slave.
>>>
>>
>> does it only happen with bonds?
> 
> All my hosts have bonds, some are just fine with your patch, but others are not.

I have a setup now where the bond is reliably showing tentative for the
address. Something to use to debug this weird little side effect.
