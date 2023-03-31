Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42B06D2998
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjCaUpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCaUpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:45:05 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 13:45:04 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362021AAD
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 13:45:04 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B962E28BC6B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 20:39:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EC3F0B80088
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 20:39:48 +0000 (UTC)
Received: from [192.168.100.159] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 754E213C2B0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 13:39:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 754E213C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1680295188;
        bh=9XFg3ksarNPJ3ME1KeTcon9Sp1uj0pnqe2/0Zp1EhI4=;
        h=Date:To:From:Subject:From;
        b=p3JJtwXEtByPtCFZhtVar1Je0/Hyicx+qWIz5aAislDX7fTndHwEDaHDO4FnMRzpr
         6SQSk4kJ+9fB0+rhJ2q/2axq7crW0BdEoq/m3oHRyNVmKifAPep5vuYg38cjbZrgB7
         lHK3qHwEkUi0vNs9ow0efpbbWc/B0GVdhNFvABwA=
Message-ID: <0fd6faaf-d05e-b0e8-4d04-03ad75340203@candelatech.com>
Date:   Fri, 31 Mar 2023 13:39:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Subject: Is udp-gro supposed to work on all network cards?
Organization: Candela Technologies
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1680295189-Y0ii2fJgqiwT
X-MDID-O: us5;ut7;1680295189;Y0ii2fJgqiwT;<greearb@candelatech.com>;0590461a9946a11a9d6965a08c2b2857
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I recently started working with udp-gro (sendmmsg extension).  It seems to work great when
sending to/from intel ax210 wifi station, but when I try on mtk7922 radio, I get -EIO from
the sendmmsg call and the data packets are not seen on the network device if I sniff.

Looks like most offloads are not enabled on this netdev.  Should I still expect udp-gro
sends to work (like with software fallback somewhere in the stack), or must I just not
use that feature on network cards not supporting it?

[root@ct523c-3b7f ~]# ethtool -k wlan20|grep ": on"
rx-checksumming: on [fixed]
generic-receive-offload: on
netns-local: on [fixed]

[root@ct523c-3b7f ~]# ethtool -k wlan20|grep udp
tx-udp_tnl-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
rx-udp-gro-forwarding: off

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

