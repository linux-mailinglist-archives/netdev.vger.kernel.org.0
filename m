Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DED1A6CE1
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbgDMT7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:59:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388135AbgDMT7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:59:20 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jO5Ej-0003pF-4y; Mon, 13 Apr 2020 19:59:17 +0000
Date:   Mon, 13 Apr 2020 21:59:15 +0200
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
Message-ID: <20200413195915.yo2l657nmtkwripb@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
 <20200413190239.GG60335@mtj.duckdns.org>
 <20200413193950.tokh5m7wsyrous3c@wittgenstein>
 <20200413194550.GJ60335@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200413194550.GJ60335@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 03:45:50PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 13, 2020 at 09:39:50PM +0200, Christian Brauner wrote:
> > Another problem is that you might have two devices of the same class
> > with the same name that belong to different namespaces and if you shown
> > them all in the initial namespace you get clashes. This was one of the
> > original reasons why network devices are only shown in the namespace
> > they belong to but not in any other.
> 
> For example, pid namespace has the same issue but it doesn't solve the problem
> by breaking up visibility at the root level - it makes everything visiable at
> root but give per-ns aliases which are selectively visble depending on the
> namespace. From administration POV, this is way easier and less error-prone to
> deal with and I was hoping that we could head that way rather than netdev way
> for new things.

Right, pid namespaces deal with a single random identifier about which
userspace makes no assumptions other than that it's a positive number so
generating aliases is fine. In addition pid namespaces are nicely
hierarchical. I fear that we might introduce unneeded complexity if we
go this way and start generating aliases for devices that userspace
already knows about and has expectations of. We also still face some of
the other problems I mentioned.
I do think that what you say might make sense to explore in more detail
for a new device class (or type under a given class) that userspace does
not yet know about and were we don't regress anything.
