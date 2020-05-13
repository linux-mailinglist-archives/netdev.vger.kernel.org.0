Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60971D1905
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389141AbgEMPUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:20:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31398 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728692AbgEMPUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589383248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jBoXYA5jC+1FdSc82MyGNu1Sk0AIstPxsVbxIsZVhsA=;
        b=bPQXgMTMqsKvo740A8vO1fTHQEDf11vAVFNExnWwgxT+M/WhPv1PBT9FOr1Vr6w6765lQt
        uLBrvi1mC53l1saCxEAhK0n6kTo17DMqFvVK3jj+LTdmHV5azbM7Mi/FJBGcW5JoZ0Dso5
        0MpWUarCptvF7AQRVXRojjra+A8ikec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-VuQquIe_OPSVs8fjvjQzFA-1; Wed, 13 May 2020 11:20:44 -0400
X-MC-Unique: VuQquIe_OPSVs8fjvjQzFA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A84583DA41;
        Wed, 13 May 2020 15:20:43 +0000 (UTC)
Received: from [10.72.12.111] (ovpn-12-111.pek2.redhat.com [10.72.12.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 264A260F8D;
        Wed, 13 May 2020 15:20:39 +0000 (UTC)
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Subject: netfilter: does the API break or something else ?
Message-ID: <cf0d02b2-b1db-7ef6-41b8-7c345b7d53d5@redhat.com>
Date:   Wed, 13 May 2020 23:20:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Experts，

Recently I hit one netfilter issue, it seems the API breaks or something 
else.

On CentOS8.1 with the recent upstream kernel built from source, such as 
5.6.0-rc6/5.7.0-rc4. When running the following command:
$ sudo bash -c 'iptables -A FORWARD -o enp3s0f1 -i ceph-brx -j ACCEPT'
iptables v1.8.2 (nf_tables): CHAIN_ADD failed (Operation not supported): 
chain INPUT

With the nftables command:

$ sudo nft add chain ip filter INPUT { type filter hook input priority 0\; }
Error: Could not process rule: Operation not supported
add chain ip filter INPUT { type filter hook input priority 0; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
$  sudo nft add chain ip filter FORWARD { type filter hook forward 
priority 0\; }
Error: Could not process rule: Operation not supported
add chain ip filter FORWARD { type filter hook forward priority 0; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
$  sudo nft add chain ip filter OUTPUT { type filter hook output 
priority 0\; }
Error: Could not process rule: Operation not supported
add chain ip filter OUTPUT { type filter hook output priority 0; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


While tried them with downstream kernel 4.18.0-147.8.1.el8_1.x86_64, 
they all could work well.

The nftables/libnftnl packages are:

$ rpm -qa|grep nft
nftables-0.9.0-14.el8.x86_64
libnftnl-1.1.1-4.el8.x86_64

And we have tried v5.7.0-rc4+ with f31 userspace, they all could work 
well too.

 From above I just suspect the API should break. Could someone kindly 
point out which and where ?
Thanks
BRs
Xiubo

