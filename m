Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F36308D7D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhA2Tgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231533AbhA2Tgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 14:36:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A93A64E09;
        Fri, 29 Jan 2021 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611948957;
        bh=Dpr9iklhJ+z/tdBn4X+vmqT1Tt6tEexfQCIfXM+sChk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tgDyDAQjBSqZKXk6ADYOfVRAeeU16Wio4mmPSlogM7dms+vY8/xjlEXJIL2MrlNlh
         Wz3A/Z2755x25urlzsNCpL9XfuiI2UR96eZhrTLdfxdF3u/1RGmqfT+rsyoLqBGOH8
         4E7OmxsErYxiCGUuc3bQprZmbgM2OIiMaSmmIomWRyOkevcMARJt1wC89n0j4zmH0e
         8I+PUEK0cPxBN2f952k1CS9A9UFSb3IVHiEssL6//zenmdIVBawN8/AnLHpNwwcyPY
         JLRw9JziEniVy0FOUcnbjNRxwMSX/LonH+XxTcmt5fBOYeFuiWSLvlfOpDh9lWY4sK
         wW3LlLJW/fRlA==
Date:   Fri, 29 Jan 2021 11:35:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
Message-ID: <20210129113555.6d361580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129114642.139cb7dc@carbon>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
        <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
        <20210129085808.4e023d3f@carbon>
        <20210129114642.139cb7dc@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 11:46:42 +0100 Jesper Dangaard Brouer wrote:
> > On Thu, 28 Jan 2021 20:51:23 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> > > A long over due look at the organization of this struct.  
> 
> Yes, I was surprised that the cache-lines used in fast-path was this
> spread out.

I tried measuring the cache misses on struct netdevice running
relatively network-heavy production workload once but they were 
really deep in the noise. Things become much easier to optimize
with a XDP micro-benchmark, but obviously should benefit all.

> There is a comment /* Cache lines mostly used on receive path */
> but that comment no-longer start on a cacheline, so I suspect that this
> have slowly diverted over time (Eric's commit 9356b8fc07 dates back to 2005).
> 
> Patch is already applied. I expected people to would say that I also
> needed to adjust the doc-type comments.  The comments describing the
> members, seems to be ordered the same way as defined.  Should we/I keep
> that order intact?  (when moving members)

kdoc didn't complain, and as you say it's already a mess, plus it's
two screen-fulls of scrolling away... 

I think converting to inline kdoc of members would be an improvement,
if you want to sign up for that? Otherwise -EDIDNTCARE on my side :)
