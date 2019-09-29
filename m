Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E98C1910
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 21:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfI2TDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 15:03:43 -0400
Received: from twin.jikos.cz ([91.219.245.39]:38805 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfI2TDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 15:03:43 -0400
X-Greylist: delayed 1939 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2019 15:03:42 EDT
Received: from twin.jikos.cz (dave@[127.0.0.1])
        by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id x8TIVIpX003182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Sun, 29 Sep 2019 20:31:19 +0200
Received: (from dave@localhost)
        by twin.jikos.cz (8.13.6/8.13.6/Submit) id x8TIVI2x003181;
        Sun, 29 Sep 2019 20:31:18 +0200
Date:   Sun, 29 Sep 2019 20:31:17 +0200
From:   David Sterba <dave@jikos.cz>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WireGuard to port to existing Crypto API
Message-ID: <20190929183117.GJ7005@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Sep 25, 2019 at 10:29:45AM +0200, Jason A. Donenfeld wrote:
> I've long resisted the idea of porting to the existing crypto API,
> because I think there are serious problems with it, in terms of
> primitives, API, performance, and overall safety. I didn't want to
> ship WireGuard in a form that I thought was sub-optimal from a
> security perspective, since WireGuard is a security-focused project.
> 
> But it seems like with or without us, WireGuard will get ported to the
> existing crypto API. So it's probably better that we just fully
> embrace it, and afterwards work evolutionarily to get Zinc into Linux
> piecemeal. I've ported WireGuard already several times as a PoC to the
> API and have a decent idea of the ways it can go wrong and generally
> how to do it in the least-bad way.
> 
> I realize this kind of compromise might come as a disappointment for
> some folks. But it's probably better that as a project we remain
> intimately involved with our Linux kernel users and the security of
> the implementation, rather than slinking away in protest because we
> couldn't get it all in at once. So we'll work with upstream, port to
> the crypto API, and get the process moving again. We'll pick up the
> Zinc work after that's done.
> 
> I also understand there might be interested folks out there who enjoy
> working with the crypto API quite a bit and would be happy to work on
> the WireGuard port. Please do get in touch if you'd like to
> collaborate.

I have some WIP code to port WG to the crypto API, more to get an idea how hard
it would be, though I read you've ported it to the api already. My other
project (btrfs) is going to use blake2 in kernel and for that I'm about to
submit the code, that's where it's also of interest for wg.

My work is at 'github.com/kdave/WireGuard branch lkca-1'. I tried to find a way
how to minimize the impact on current wg code but make it possible to
iteratively extend it to the crypto API.

So, there's some config-time ifdefery to select which crypto functions are
using kernel or zinc api.  See wg.git/src/crypto/Kbuild.include at the top,
plus some source ifdefs.  I made an example of blake2s port, but only compile
tested.

There are several problems in general that need to be solved on the kernel side
first, before wireguard can work inside the kernel code base:

* missing crypto functions in kernel
  * blake2
  * curve25519 (missing completely)

* missing generic crypto API callback to use blake_init_key, it's possible to
  use only the no-key variant (I have a patch for that, it's really easy but
  it's change in API so ...)

The known problem is the cumbersome way to use the crypto functions, eg. for
chacha/poly, I understand the pain and perhaps the reasons to start a fresh
crypto library. I'm afraid the first implementation with current state of
crypto API will be slow, until the API is extended to provide simple ways to
transform buffers without scatterlists, request allocations, locking tfm
context and whatnot.

Feel free to reuse anything from the code if you think it's going the right
direction. I'm not sure if I'll have time to continue with the port but at
least you can consider blake2 on the way upstream.

d.
