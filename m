Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7E19D942
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391042AbgDCOhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:37:21 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:60718 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390796AbgDCOhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:37:21 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 55A332E151A;
        Fri,  3 Apr 2020 17:37:18 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 5Ty4DonBRu-bHiSwSOI;
        Fri, 03 Apr 2020 17:37:18 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585924638; bh=rZPKF6obiJ/krD77h4NfxBs/gQ6MdBgNCuwQmy0+SWU=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Bi7CnL9+JFSdwQ7EcUVkkhRpD2i2IdQXd0BcCfjJsFqxyEALDQ7lW5MnXX+LRXBh6
         qx4CRVbfV5SdaYxpmSh1nqIMimnKICDPWUz+q2icQ/ZieWYbpb7l6sRNPQ0f2rOj3b
         ve+YHvl6czWpRy/Hld+/U7WxNsNN0AUww4jSXlhM=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:8910::1:6])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id YfNmyTPKzN-bHWmcnfE;
        Fri, 03 Apr 2020 17:37:17 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
To:     Tejun Heo <tj@kernel.org>, Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, bpf@vger.kernel.org
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
Date:   Fri, 3 Apr 2020 17:37:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200403133817.GW162390@mtj.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2020 16.38, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
>> This patch adds cgroup v2 ID to common inet diag message attributes.
>> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
>> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
>> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
>> cgroup ID) for newly created sockets.
>>
>> Some notes about this ID:
>>
>> 1) gets initialized in socket() syscall
>> 2) incoming socket gets ID from listening socket
>>     (not during accept() syscall)
> 
> How would this work with things like inetd? Would it make sense to associate the
> socket on the first actual send/recv?

First send/recv seems too intrusive.
Setsockopt to change association to current cgroup (or by id) seems more reasonable.

Systemd variant of inetd handles sockets as separate units and probably
creates own cgroups for them.

> 
> Thanks.
> 
