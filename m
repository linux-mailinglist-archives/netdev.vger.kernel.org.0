Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB311A3AAC
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDITkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:40:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgDITkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:40:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7807AD60;
        Thu,  9 Apr 2020 19:40:14 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C1B4CE009C; Thu,  9 Apr 2020 21:40:14 +0200 (CEST)
Date:   Thu, 9 Apr 2020 21:40:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Konstantin Kharlamov <hi-angel@yandex.ru>, linville@tuxdriver.com
Subject: Re: (repost for 2020y) inconsistency of ethtool feature names for
 get vs. set
Message-ID: <20200409194014.GN3141@unicorn.suse.cz>
References: <36ca2996-ea04-f050-5f88-7edef5a88f26@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca2996-ea04-f050-5f88-7edef5a88f26@yandex.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 04:07:39PM +0300, Konstantin Kharlamov wrote:
> I noticed some inconsistency of feature names with the ethtool getting/setting of features mechanics -- the name of the feature you need to set (through -K) isn't what displayed by the get (-k) directive, here's an example:
> 
> $ ethtool -k eth1  | grep generic-receive-offload
> generic-receive-offload: on
> 
> $ ethtool -K eth1  generic-receive-offload off
> ethtool: bad command line argument(s)
> For more information run ethtool -h
> 
> --> looking in the sources and realizing I need to use "rx-gro"
> 
> $ ethtool -K eth1  rx-gro on
> 
> $ethtool -k eth1  | grep generic-receive-offload
> generic-receive-offload: on
> 
> same problem for rx checksum which is displayed as "rx-checksumming" by the get (-k)
> but need to be "rx-checksum" for the set (-K) directive.

This is actually going to work with netlink implementation in kernel
5.7-rc1 (or current mainline) and corresponding userspace patchset I'm
going to submit after ethtool 5.6 is released:

  lion:~ # ~mike/work/git/ethtool/ethtool -k dummy0 | grep generic-receive-offload
  generic-receive-offload: on
  lion:~ # ~mike/work/git/ethtool/ethtool -K dummy0 generic-receive-offload off
  Actual changes:
  rx-gro: off
  lion:~ # ~mike/work/git/ethtool/ethtool -k dummy0 | grep generic-receive-offload
  generic-receive-offload: off

(The "rx-gro" in "Actual changes" section which probably comes from
using a dump function in ioctl code. I'll look into it.)

But independent of that, the ioctl code path should also accept actual
feature names provided by kernel. I'll try to find where the problem is
and fix it.

Michal Kubecek
