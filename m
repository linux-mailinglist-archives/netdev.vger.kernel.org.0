Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF45E3B064F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhFVN5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:57:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231489AbhFVN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qzQX2KViayf+GEN+lZmxdUc6t+8BAh2HS0IqSp5hmAI=;
        b=WyYtHOIHTPVfFpSrgeJJQPJy3TLsltNAax0FIxD5DkzsGtKwXxrWVyfAi2ZBT9Dj4Nn8gP
        4n4TtDQ+ZbFmsaPxk6uMn1GjgeKAGVPRLZpaCrv9Xy6WTLmu94wwvLUdegIhdFiH/woCIS
        tlIgdEnyXSxS/DdLnrMH4AEAT7l167I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-uajx7EhNOxGpz6Lfu3NSPQ-1; Tue, 22 Jun 2021 09:55:29 -0400
X-MC-Unique: uajx7EhNOxGpz6Lfu3NSPQ-1
Received: by mail-ej1-f71.google.com with SMTP id j26-20020a170906411ab02904774cb499f8so5251420ejk.6
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=qzQX2KViayf+GEN+lZmxdUc6t+8BAh2HS0IqSp5hmAI=;
        b=fm1Lg7AerRcsRhcFltH1S6XY3jQGFV3kAaESnS1h1WzU/1SSPUVS64j5Av8caHXGzs
         Ta/M2TzMFGO8zZxNbokIno3cJC8Vz3aTWfqBywtRLIh6Q0noToYb8+6zsLJFxZGbsyLk
         fswYLAQNsUlx7F5U/xDRnqOPKxnnT2AAM9RuDUuI5+TlFx0jE+TBAKcCj+CaMWDRpJqN
         qtIYWSeAJ/xnDBaOFBCFuziNyjrKP2uCNqbJ8aMOYoTi0XjRZBb9qAScMVXbEYqXxfVM
         +MhVP7+/pSbvHTBhPrfEwqTdf8eJKFhz8MZdHVNZKhuiaGTrSIEZ0JEWVpHUBxbNfBjw
         DLLg==
X-Gm-Message-State: AOAM531Vc1bQc3l2WQ7EeydOZ390eaJbu2g1QLoGxfZUAlRFPkyA3YFx
        +IwYkgOnhTGCSkBM2+Gv76NRfbgkhE+q80DZXHZbSEWKxEJwWz7Wf3Rc+keO98GocIrAT3LERbP
        EkVDvqn+CDj+6/Mr5
X-Received: by 2002:a17:906:b2cb:: with SMTP id cf11mr4195738ejb.448.1624370128009;
        Tue, 22 Jun 2021 06:55:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb1TNMJFG6xjXhaguKY21enOi4mhulDzTxsMTnhHxtwu6vvwF5MwWuMh4+l/NNhJFFYG7AcA==
X-Received: by 2002:a17:906:b2cb:: with SMTP id cf11mr4195700ejb.448.1624370127498;
        Tue, 22 Jun 2021 06:55:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id du7sm12122343edb.1.2021.06.22.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 06:55:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 252D618071E; Tue, 22 Jun 2021 15:55:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <87zgvirj6g.fsf@toke.dk>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Jun 2021 15:55:25 +0200
Message-ID: <87r1guovg2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

>> It would also be great if this scenario in general could be placed
>> under the Documentation/RCU/whatisRCU.rst as an example, so we could
>> refer to the official doc on this, too, if Paul is good with this.
>
> I'll take a look and see if I can find a way to fit it in there...

OK, I poked around in Documentation/RCU and decided that the most
natural place to put this was in checklist.rst which already talks about
local_bh_disable(), but a bit differently. Fixing that up to correspond
to what we've been discussing in this thread, and adding a mention of
XDP as a usage example, results in the patch below.

Paul, WDYT?

-Toke



diff --git a/Documentation/RCU/checklist.rst b/Documentation/RCU/checklist.=
rst
index 1030119294d0..e5bc93e8f9f5 100644
--- a/Documentation/RCU/checklist.rst
+++ b/Documentation/RCU/checklist.rst
@@ -226,12 +226,16 @@ over a rather long period of time, but improvements a=
re always welcome!
 	broken kernels, and has even resulted in an exploitable security
 	issue.
=20
-	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
-	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
-	in cases where local bottom halves are already known to be
-	disabled, for example, in irq or softirq context.  Commenting
-	such cases is a must, of course!  And the jury is still out on
-	whether the increased speed is worth it.
+	One exception to this rule: a pair of local_bh_disable() /
+	local_bh_enable() calls function like one big RCU read-side critical
+	section, so separate rcu_read_lock()s can be omitted in cases where
+	local bottom halves are already known to be disabled, for example, in
+	irq or softirq context. Commenting such cases is a must, of course!
+	One notable example of this usage is the XDP feature in networking,
+	which calls BPF programs from network-driver NAPI (softirq) context.
+	BPF relies heavily on RCU protection for its data structures, but
+	because the BPF program invocation happens entirely within a single
+	local_bh_disable() section in a NAPI poll cycle, this usage is safe.
=20
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
 	usually results in simpler code.  So, unless update performance is

