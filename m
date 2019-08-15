Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BCA8E9DE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbfHOLMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:12:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37935 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHOLMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:12:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so1815972edo.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 04:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ntIsD69DO/hO6b75AtxLAE4j1t2W0/fwbe66EmMsreM=;
        b=pKXNbRGn3LnB3wF/N0hmWBwh2wH4rSCM7LAmjTA6hXZI4yNs27BoCFM/2nK/VCBHgn
         A8fIxIFk3ISImt15XkO068bSnikvSywCyU1YlFLQKJut1nkZKfjArVgbg/PnedsIIV4r
         XoNlDgoqKav5Wpxm7gQWlkPw+P1Efk+Y0GE+LBAwr5CaHb9ikQhushSK0tIGpalw/QKB
         +GoY+aH38KKzhOyOepE/EnfOYp1SwpNZvSlhJuMEFbB47bRZp1ETUH6/1dFO4mJ+3yDd
         oJ5AHYu7hEujjPPgO0LEHcUPPNgCg+7oj6dG4+mez3pP1WtdoOFPYbZsH8i5B8+Yyk8c
         L4DQ==
X-Gm-Message-State: APjAAAWyBqAIWUJVp7n7ZF0+ZGWED8i/M0s0lh2LbPrv0CcaN8zL4D00
        Kjbey1Q7T/x8T4oem2s9Zj0Ikg==
X-Google-Smtp-Source: APXvYqySmryfwFB28Qyo1faZoMqbuRI9iUKmVaJDkDfpefaX3OWKGu+Vwl+P/M8P9UMOyLYn7wa1rA==
X-Received: by 2002:aa7:d755:: with SMTP id a21mr4711292eds.295.1565867559112;
        Thu, 15 Aug 2019 04:12:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c15sm505684edf.37.2019.08.15.04.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 04:12:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 00332181C2E; Thu, 15 Aug 2019 13:12:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 0/5] Add support for SKIP_BPF flag for AF_XDP sockets
In-Reply-To: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Aug 2019 13:12:37 +0200
Message-ID: <87ftm2adi2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sridhar Samudrala <sridhar.samudrala@intel.com> writes:

> This patch series introduces XDP_SKIP_BPF flag that can be specified
> during the bind() call of an AF_XDP socket to skip calling the BPF 
> program in the receive path and pass the buffer directly to the socket.
>
> When a single AF_XDP socket is associated with a queue and a HW
> filter is used to redirect the packets and the app is interested in
> receiving all the packets on that queue, we don't need an additional 
> BPF program to do further filtering or lookup/redirect to a socket.
>
> Here are some performance numbers collected on 
>   - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>   - Intel 40Gb Ethernet NIC (i40e)
>
> All tests use 2 cores and the results are in Mpps.
>
> turbo on (default)
> ---------------------------------------------	
>                       no-skip-bpf    skip-bpf
> ---------------------------------------------	
> rxdrop zerocopy           21.9         38.5 
> l2fwd  zerocopy           17.0         20.5
> rxdrop copy               11.1         13.3
> l2fwd  copy                1.9          2.0
>
> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
> ---------------------------------------------	
>                       no-skip-bpf    skip-bpf
> ---------------------------------------------	
> rxdrop zerocopy           15.4         29.0
> l2fwd  zerocopy           11.8         18.2
> rxdrop copy                8.2         10.5
> l2fwd  copy                1.7          1.7
> ---------------------------------------------

You're getting this performance boost by adding more code in the fast
path for every XDP program; so what's the performance impact of that for
cases where we do run an eBPF program?

Also, this is basically a special-casing of a particular deployment
scenario. Without a way to control RX queue assignment and traffic
steering, you're basically hard-coding a particular app's takeover of
the network interface; I'm not sure that is such a good idea...

-Toke
