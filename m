Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1F5617D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 06:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFZEhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 00:37:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43181 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfFZEhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 00:37:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so968895wru.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 21:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I182T36a9AcOI5GNaQFiflRFqr6MYJO2H0ynTDuRZ+I=;
        b=n/oYELOKudEF1dQ9B3xmm/oxxOtXjH9kwYsmLCfsLc1Anctl5yMSCX0g2VW73ofEUi
         Z/Sg/nx2aIn2jfnMZasdtxctTIkgx9BmE/OtLjChbPG1uISEqXapAxufUG2GYbQfcXyw
         ORr+ssdyaF6MGpU6VdbVZIEfTd4oJfjlLTAMyb8snES4wFfXtc7AZIpPGGqHWz4AM33e
         up5+o1+vjUu64S1MbTGLr2Udb7vsufM1FpaAKPKckeOxJ8mfk86dsU+ShWv6K/YtjqxV
         x+/ZdsZlPkVLNULdwF2/gs7oe/wXFgrAbIrI9rUbLR4pyifIf3Bs6t+qswpn7iVOwD8E
         v9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I182T36a9AcOI5GNaQFiflRFqr6MYJO2H0ynTDuRZ+I=;
        b=M9YJ+BCtS8HOtelYkljtkfqGKqQm7Ss6dfon6lyeiX9moWBJfIVOUtXZvLflLLBOFm
         ElRalEhmExsGgCRsSOvKDjFC9tARYFf7IL7epjmztHF7vikb+P+HARdXnIV8WSGdjOvL
         HNgNiv8D139NGdCAxL+PEAKea7x54iKyv67Tg8Ddow2g3/d9nXXll72WXmOmtYhawM9r
         r5vDMTmL4RWlIgqj2HqePzfEwRc5Jf7Kbn0KA4aZ22SJio/BtPnIHawWMENBeztCEi8Z
         7enAQGGtYrWwCGU/qp/7jt2Ma91iojGjZvvwELCVzoitEWussAv3IKSLfvJa2dbvI10z
         NYQA==
X-Gm-Message-State: APjAAAUKum3Gfk/jU/f8B2SFj4Nbr1us3OlfnUSNkUesBzt7azjk7bYk
        4wYJo1TO/aY9uCdbffx6h0w=
X-Google-Smtp-Source: APXvYqw4ateMOMxFQs4NQFdrB34pCncnuX0/j+c19pJeLMRai4jF2K6nxLbqTDxuuJ3vpY4eJVLpHQ==
X-Received: by 2002:adf:81c8:: with SMTP id 66mr1390991wra.261.1561523830800;
        Tue, 25 Jun 2019 21:37:10 -0700 (PDT)
Received: from jimi (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id v18sm13904119wrs.80.2019.06.25.21.37.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 21:37:10 -0700 (PDT)
Date:   Wed, 26 Jun 2019 07:37:03 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Hurley <john.hurley@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, shmulik@metanetworks.com
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
Message-ID: <20190626073703.5655f7b1@jimi>
In-Reply-To: <4a4f2f81-d87a-2a45-36b9-ac101d937219@mojatatu.com>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
        <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
        <20190625113010.7da5dbcb@jimi>
        <CAK+XE=mOjtp16tdz83RZ-x_jEp3nPRY3smxbG=OfCmGi9_DnXg@mail.gmail.com>
        <4a4f2f81-d87a-2a45-36b9-ac101d937219@mojatatu.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal, John,

On Tue, 25 Jun 2019 07:24:37 -0400
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> On 2019-06-25 5:06 a.m., John Hurley wrote:
> > On Tue, Jun 25, 2019 at 9:30 AM Eyal Birger <eyal.birger@gmail.com>
> > wrote:  
> 
> > I'm not sure on the history of why a value of 4 was selected here
> > but it seems to fall into line with my findings.  
> 
> Back then we could only loop in one direction (as opposed to two right
> now) - so seeing something twice would have been suspect enough,
> so 4 seems to be a good number. I still think 4 is a good number.

I think the introduction of mirred ingress affects the 'seeing something
twice is suspicious' paradigm - see below.

> > Is there a hard requirement for >4 recursive calls here?  
> 
> I think this is where testcases help (which then get permanently
> added in tdc repository). Eyal - if you have a test scenario where
> this could be demonstrated it would help.

I don't have a _hard_ requirement for >4 recursive calls.

I did encounter use cases for 2 layers of stacked net devices using TC
mirred ingress. For example, first layer redirects traffic based on
incoming protocol - e.g. some tunneling criterion - and the second
layer redirects traffic based on the IP packet src/dst, something like:

  +-----------+  +-----------+  +-----------+  +-----------+
  |    ip0    |  |    ip1    |  |    ip2    |  |    ip3    |
  +-----------+  +-----------+  +-----------+  +-----------+
          \          /                 \           /
           \        /                   \         /
         +-----------+                 +-----------+
         |   proto0  |                 |   proto1  |
         +-----------+                 +-----------+
                    \                   /
                     \                 /
                        +-----------+
                        |    eth0   |
                        +-----------+

Where packets stem from eth0 and are redirected to the appropriate devices
using mirred ingress redirect with different criteria.
This is useful for example when each 'ip' device is part of a different
routing domain.

There are probably many other ways to do this kind of thing, but using mirred
ingress to demux the traffic provides freedom in the demux criteria while
having the benefit of a netdevice at each node allowing to use tcpdump and
other such facilities.

As such, I was concerned that a hard limit of 4 may be restrictive.

I too think Florian's suggestion of using netif_rx() in order to break
the recursion when limit is met (or always use it?) is a good approach
to try in order not to force restrictions while keeping the stack sane.

Eyal.
