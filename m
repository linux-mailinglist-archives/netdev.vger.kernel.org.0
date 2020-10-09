Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDC328874E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgJIKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIKsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:48:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED3BC0613D2;
        Fri,  9 Oct 2020 03:48:08 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQpwT-002DQX-Vr; Fri, 09 Oct 2020 12:48:06 +0200
Message-ID: <2a333c2a50c676c461c1e2da5847dd4024099909.camel@sipsolutions.net>
Subject: Re: [RFC] debugfs: protect against rmmod while files are open
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-kernel@vger.kernel.org
Cc:     nstange@suse.de, ap420073@gmail.com, David.Laight@aculab.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org
Date:   Fri, 09 Oct 2020 12:48:05 +0200
In-Reply-To: <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid> (sfid-20201009_124139_179083_C8D99C3A)
References: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
         <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid>
         (sfid-20201009_124139_179083_C8D99C3A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 12:41 +0200, Johannes Berg wrote:

> If the fops doesn't have a release method, we don't even need
> to keep a reference to the real_fops, we can just fops_put()
> them already in debugfs remove, and a later full_proxy_release()
> won't call anything anyway - this just crashed/UAFed because it
> used real_fops, not because there was actually a (now invalid)
> release() method.

I actually implemented something a bit better than what I described - we
never need a reference to the real_fops for the release method alone,
and that means if the release method is in the kernel image, rather than
a module, it can still be called.

That together should reduce the ~117 places you changed in the large
patchset to around a handful.

johannes

