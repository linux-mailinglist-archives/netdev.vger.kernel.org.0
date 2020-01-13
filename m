Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE96513985E
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAMSLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:11:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35675 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726878AbgAMSLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 13:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578939061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0GiC4x1xyl7Nxzus/W1mb/zYOcTy1w7cfVX4WnGR3Cw=;
        b=KslWuBKjHoJm0kbTL0wDb1K2lZ2i5KNpHAz1lb6MKskZZIl+sF4pWusgSPFklyoKl3r4Bq
        dEVTlyeyvGZ5VtQSWCLcAZMg9C5wKwkR+EgUhNLb2j05aT8Q3/FQSm+ulNG5GSvvvEVxyO
        I8qSjmcwrTMuW/THPzcRQ9lLE+jp06w=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-OgxpwCZ7MMCSLLyPiXefcQ-1; Mon, 13 Jan 2020 13:10:58 -0500
X-MC-Unique: OgxpwCZ7MMCSLLyPiXefcQ-1
Received: by mail-lj1-f197.google.com with SMTP id k21so2282224ljg.3
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 10:10:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=0GiC4x1xyl7Nxzus/W1mb/zYOcTy1w7cfVX4WnGR3Cw=;
        b=CSUrqFCoN7l12wJwf4Zah0tKi6F9j4auzccpGAbcIWLWwn7+K5KvjPqtNNGQ7LeJtf
         tCeW0lw8VBoGtpTIIOqTkl2T4kAinVNCVww7ILY/Q1Rb1NJUtaOdqiMytx1laucUtA2G
         7DT10eSjr7E8/Jjf3vw6L6RUCMi41C2qh1cDEp+NrXGOKiPD/omrOuoEPlRDCG2vKQkt
         NuBdOgdu4iL8RmXlE0wurkPilvKSZfZGlnVxDZMjKWvAK65gglKzB5OXpA66v22Lyrr9
         VedOm0DEIyi6HSDCOZ2yCVyArRBAEJk8cRB70Em1+37BipOxh0W/id52KDMntT/g7C5Q
         zbFg==
X-Gm-Message-State: APjAAAUK/Vsi8COXRp/gcwNl1LhQfpwcM9cNMyUz7zUpewYc5wbMr+hf
        TikEMGc3Gvn5X6X+lKw4iGG7tjLla4p1QhBHlhbcGzssRUbGYzlcyGZlpJRYJLNN7fhcj44/F88
        p2QT0glhgnaOwCUgd
X-Received: by 2002:a2e:96c6:: with SMTP id d6mr11768033ljj.4.1578939056411;
        Mon, 13 Jan 2020 10:10:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqykskaBPu0tmqGarkd/Rbms3XY/pthHACGXXDa0CI//T1u2y4oAh8xB39NNgMYjNM3ZB0OOVw==
X-Received: by 2002:a2e:96c6:: with SMTP id d6mr11768022ljj.4.1578939056212;
        Mon, 13 Jan 2020 10:10:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i4sm7335829lji.0.2020.01.13.10.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 10:10:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE63D1804D6; Mon, 13 Jan 2020 19:10:54 +0100 (CET)
Subject: [PATCH bpf-next v2 0/2] xdp: Introduce bulking for non-map
 XDP_REDIRECT
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Date:   Mon, 13 Jan 2020 19:10:54 +0100
Message-ID: <157893905455.861394.14341695989510022302.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 96360004b862 ("xdp: Make devmap flush_list common for all map
instances"), devmap flushing is a global operation instead of tied to a
particular map. This means that with a bit of refactoring, we can finally fix
the performance delta between the bpf_redirect_map() and bpf_redirect() helper
functions, by introducing bulking for the latter as well.

This series makes this change by moving the data structure used for the bulking
into struct net_device itself, so we can access it even when there is not
devmap. Once this is done, moving the bpf_redirect() helper to use the bulking
mechanism becomes quite trivial, and brings bpf_redirect() up to the same as
bpf_redirect_map():

                       Before:   After:
1 CPU:
bpf_redirect_map:      8.4 Mpps  8.4 Mpps  (no change)
bpf_redirect:          5.0 Mpps  8.4 Mpps  (+68%)
2 CPUs:
bpf_redirect_map:     15.9 Mpps  16.1 Mpps  (+1% or ~no change)
bpf_redirect:          9.5 Mpps  15.9 Mpps  (+67%)

After this patch series, the only semantics different between the two variants
of the bpf() helper (apart from the absence of a map argument, obviously) is
that the _map() variant will return an error if passed an invalid map index,
whereas the bpf_redirect() helper will succeed, but drop packets on
xdp_do_redirect(). This is because the helper has no reference to the calling
netdev, so unfortunately we can't do the ifindex lookup directly in the helper.

Changelog:

v2:
  - Consolidate code paths and tracepoints for map and non-map redirect variants
    (Björn)
  - Add performance data for 2-CPU test (Jesper)
  - Move fields to avoid shifting cache lines in struct net_device (Eric)

---

Toke Høiland-Jørgensen (2):
      xdp: Move devmap bulk queue into struct net_device
      xdp: Use bulking for non-map XDP_REDIRECT and consolidate code paths


 include/linux/bpf.h        |   13 +++++-
 include/linux/netdevice.h  |   11 +++--
 include/trace/events/xdp.h |  104 +++++++++++++++++++-------------------------
 kernel/bpf/devmap.c        |   94 +++++++++++++++++++++-------------------
 net/core/dev.c             |    2 +
 net/core/filter.c          |   86 +++++++-----------------------------
 6 files changed, 132 insertions(+), 178 deletions(-)

