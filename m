Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95A8F1A3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbfHORLO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Aug 2019 13:11:14 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32834 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731299AbfHORLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:11:13 -0400
Received: by mail-ed1-f66.google.com with SMTP id s15so2730889edx.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 10:11:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DG21KkKuGbE22qd7U7CNhzev33PvnhgSnKWOMcxhx0o=;
        b=M8EoW/er56zqQazD0qUJVXsVD5yZkdlvgiODcueBo39pahWNbOg3sp9yamvVPJQo0u
         37qCRNiwtvqApX0bwSpztOUK68upQjlPubmhRYAEdWlgBi7q3eCdoX1s6Sy7aZj3KXVG
         JfJJyBc0NoQFKpjspZC8k/W4X+x2z90vWK81cidsLXDAHR6zrXUMVDJehpBMBxmsUZbg
         ztj5kJ4cxMN+ffHgXRhuGwUyWZKVh+AjANS59liz63GKt4lteK4BCLmSNrnxF+nWWwzR
         m13fusDiXchcNmuHlz8qfWvgfETBwwzU44DIkfQ5gvqtB8uQDDQ+S96PQa0iCThpVcBh
         57dQ==
X-Gm-Message-State: APjAAAWdTXGBGO0lI5Pir0GzElQ2lH483KojUTvpXpdsDNH+AQV/Fsl+
        GkAhZBq/90OWM+wA1KkoBSvQEA==
X-Google-Smtp-Source: APXvYqwBCG6PXQ1zbJIvWQF6cb4SXcTTFbXx1veojnlRTDWLgRqtU+ZpZEdGvpBGRpyLhNF7FITOQg==
X-Received: by 2002:a17:906:eb8d:: with SMTP id mh13mr5279618ejb.98.1565889072181;
        Thu, 15 Aug 2019 10:11:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w14sm652036edf.7.2019.08.15.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:11:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 224FB181C2E; Thu, 15 Aug 2019 19:11:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Samudrala\, Sridhar" <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 0/5] Add support for SKIP_BPF flag for AF_XDP sockets
In-Reply-To: <b9423054-247e-8b57-ea59-42368f60ea1e@intel.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com> <87ftm2adi2.fsf@toke.dk> <b9423054-247e-8b57-ea59-42368f60ea1e@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Aug 2019 19:11:11 +0200
Message-ID: <87ftm2wdzk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Samudrala, Sridhar" <sridhar.samudrala@intel.com> writes:

> On 8/15/2019 4:12 AM, Toke Høiland-Jørgensen wrote:
>> Sridhar Samudrala <sridhar.samudrala@intel.com> writes:
>> 
>>> This patch series introduces XDP_SKIP_BPF flag that can be specified
>>> during the bind() call of an AF_XDP socket to skip calling the BPF
>>> program in the receive path and pass the buffer directly to the socket.
>>>
>>> When a single AF_XDP socket is associated with a queue and a HW
>>> filter is used to redirect the packets and the app is interested in
>>> receiving all the packets on that queue, we don't need an additional
>>> BPF program to do further filtering or lookup/redirect to a socket.
>>>
>>> Here are some performance numbers collected on
>>>    - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>>>    - Intel 40Gb Ethernet NIC (i40e)
>>>
>>> All tests use 2 cores and the results are in Mpps.
>>>
>>> turbo on (default)
>>> ---------------------------------------------	
>>>                        no-skip-bpf    skip-bpf
>>> ---------------------------------------------	
>>> rxdrop zerocopy           21.9         38.5
>>> l2fwd  zerocopy           17.0         20.5
>>> rxdrop copy               11.1         13.3
>>> l2fwd  copy                1.9          2.0
>>>
>>> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
>>> ---------------------------------------------	
>>>                        no-skip-bpf    skip-bpf
>>> ---------------------------------------------	
>>> rxdrop zerocopy           15.4         29.0
>>> l2fwd  zerocopy           11.8         18.2
>>> rxdrop copy                8.2         10.5
>>> l2fwd  copy                1.7          1.7
>>> ---------------------------------------------
>> 
>> You're getting this performance boost by adding more code in the fast
>> path for every XDP program; so what's the performance impact of that for
>> cases where we do run an eBPF program?
>
> The no-skip-bpf results are pretty close to what i see before the 
> patches are applied. As umem is cached in rx_ring for zerocopy the 
> overhead is much smaller compared to the copy scenario where i am 
> currently calling xdp_get_umem_from_qid().

I meant more for other XDP programs; what is the performance impact of
XDP_DROP, for instance?

>> Also, this is basically a special-casing of a particular deployment
>> scenario. Without a way to control RX queue assignment and traffic
>> steering, you're basically hard-coding a particular app's takeover of
>> the network interface; I'm not sure that is such a good idea...
>
> Yes. This is mainly targeted for application that create 1 AF_XDP
> socket per RX queue and can use a HW filter (via ethtool or TC flower)
> to redirect the packets to a queue or a group of queues.

Yeah, and I'd prefer it if the handling of this to be unified somehow...

-Toke
