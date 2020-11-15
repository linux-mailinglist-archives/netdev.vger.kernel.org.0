Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6710D2B370D
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgKORT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:19:29 -0500
Received: from yes.iam.tj ([109.74.197.121]:49030 "EHLO iam.tj"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726704AbgKORT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 12:19:29 -0500
Received: from [10.0.40.123] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id 554AE340AD;
        Sun, 15 Nov 2020 17:19:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1605460767; bh=DlZkI/8PRQ6TIYsv1ehfyt9yCqdCFwmbjsPMe7P3FDY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=p8U11+QPR8bog1eswE2Zw8P+QeuhrsmgvVUc02pihjPGZxAiVSbPjAILK1QC+Q2Pd
         i1TTd5GE7XVDDvwS2D0GeC9blundnAvi1HJ5iM/2yLkUI9K4hFh/LJkES5xt2iYKdj
         8W20Hyfh13YZLjiFGP+D2+suFsLhzdRxPxyxXSvFcc0oy/zFhB9iJCHgnX4BHDSWfx
         wSZOM1UiNd8w8poTUFMSs6PGqb7AMH98GKpTCSUAOsxBw8A/2Ecl4CJMHaD557ewws
         1wK0X8oIgmwwogVbkHOQhMcxq3A+U/tS8PatOrSea4dXmMHFiiC6Lld5OpUELrY1+4
         Hr6pRwGc7Ju5A==
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz, f.fainelli@gmail.com,
        marek.behun@nic.cz, vivien.didelot@gmail.com, info <info@turris.cz>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
 <20201114184915.fv5hfoobdgqc7uxq@skbuf>
 <c0bb216e-0717-a131-f96d-c5194b281746@elloe.vision>
 <20201115160244.GD1701029@lunn.ch>
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Organization: Elloe CIC
Message-ID: <79ad87d1-15e0-7ccc-e1ad-4aab3fdf0d20@elloe.vision>
Date:   Sun, 15 Nov 2020 17:19:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115160244.GD1701029@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[On 15/11/2020 16:02, Andrew Lunn wrote:

> What might be interesting is running
> 
> ip monitor
> 
> and
> 
> bridge monitor
> 
> Look for neighbours being timed out do to inactivity.

Funny you write that! This afternoon I've narrowed it down although I
still don't understand the 'why'.

Watching on the 'good' (lab) and 'bad' (gateway) Mox devices I noticed that:

# bridge -d -s mdb show

23: br-lan  br-lan  ff02::2  temp   257.05

23: br-lan  br-lan  ff05::2  temp   257.05

23: br-lan  br-lan  ff02::6a  temp   257.05
23: br-lan  br-lan  ff02::1:ff77:2b20  temp   257.05
23: br-lan  br-lan  ff02::1:ff00:ffff  temp   257.05

23: br-lan  br-lan  ff02::fb  temp   257.05

23: br-lan  br-lan  ff02::1:ff00:0  temp   257.05
23: br-lan  br-lan  ff02::1:2  temp   257.05
23: br-lan  br-lan  ff05::1:3  temp   257.05

indicates that the entries time out on 'bad' but are reset to a high
value on 'good'

# bridge monitor on 'bad' reported:

Deleted Deleted 23: br-lan  br-lan  ff02::2  temp
Deleted Deleted 23: br-lan  br-lan  ff05::2  temp
Deleted Deleted 23: br-lan  br-lan  ff02::6a  temp
Deleted Deleted 23: br-lan  br-lan  ff02::1:ff77:2b20  temp
Deleted Deleted 23: br-lan  br-lan  ff02::1:ff00:ffff  temp
Deleted Deleted 23: br-lan  br-lan  ff02::fb  temp
Deleted Deleted 23: br-lan  br-lan  ff02::1:ff00:0  temp
Deleted Deleted 23: br-lan  br-lan  ff02::1:2  temp
Deleted Deleted 23: br-lan  br-lan  ff05::1:3  temp

On the laptop I'm testing from (tcpdump always on the laptop):

Using tcpdump I *think* enp2s0 (wired link direct into lan1 on 'good')
always showed the laptop sending multicast listener report v2 packets on
a regular cadence of about 60-100 seconds as well as the DHCPv6
solicit/renews and that cadence matched when the timers on the output of
"bridge -d -s mdb show" reset to approximately 258.

But for wlp4s0 (wifi to 'bad') the DHCPv6 solicit/renew didn't seem to
be accompanied by multicast listener reports and the mdb timers expired.

I need to re-affirm that tomorrow because I've got slightly lost
attempting to compare multiple aspects on both 'good' and 'bad' and seem
to be seeing inconsistent results.

On the laptops we are using Xubuntu 20.04 amd64 with NetworkManager.
I'll try to test from a range of different devices tomorrow in case this
is only affecting staff laptops.

Many thanks for the pointers.
