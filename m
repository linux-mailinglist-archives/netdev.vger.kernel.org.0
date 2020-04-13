Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F9C1A6CA0
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbgDMTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:40:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45325 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbgDMTj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:39:58 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jO4vw-0002kH-3i; Mon, 13 Apr 2020 19:39:52 +0000
Date:   Mon, 13 Apr 2020 21:39:50 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/8] kernfs: let objects opt-in to propagating from the
 initial namespace
Message-ID: <20200413193950.tokh5m7wsyrous3c@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
 <20200413190239.GG60335@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200413190239.GG60335@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 03:02:39PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 08, 2020 at 05:21:48PM +0200, Christian Brauner wrote:
> > The initial namespace is special in many ways. One feature it always has
> > had is that it propagates all its devices into all non-initial
> > namespaces. This is e.g. true for all device classes under /sys/class/
> 
> Maybe I'm missing your point but I've always thought of it the other way
> around. Some namespaces make all objects visible in init_ns so that all
> non-init namespaces are subset of the init one, which sometimes requires
> creating aliases. Other namespaces don't do that. At least in my experience,
> the former is a lot easier to administer.
> 
> The current namespace support in kernfs behaves the way it does because the
> only namespace it supports is netns, but if we're expanding it, I think it
> might be better to default to init_ns is superset of all others model and make
> netns opt for the disjointing behavior.

Hey Tejun,

The point was that devices have always been shown in all namespaces. You
can see all devices everywhere. Sure that wasn't ideal but we can't
really change that behavior since it would break userspace significantly
as a lot of tools are used to that behavior.

Another problem is that you might have two devices of the same class
with the same name that belong to different namespaces and if you shown
them all in the initial namespace you get clashes. This was one of the
original reasons why network devices are only shown in the namespace
they belong to but not in any other.

The network model of only showing the device in the namespace they belong
to also has the advantage that tools do not stomp on each others feet
when using them.
