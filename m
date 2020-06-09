Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397E51F4226
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbgFIR0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgFIR0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:26:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D3CC05BD1E;
        Tue,  9 Jun 2020 10:26:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so8292983plo.7;
        Tue, 09 Jun 2020 10:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0WCBbKlN3H2RLMXFyw7xfGn8ug6YqjVteAv3Iz89Go=;
        b=YxyXQEdb19IlluMtrrYyZkmuPZufBxjhbsS1ZmiQxrFW+mUL+uYd8NEQ+CM1hqBTco
         C3NIS+Gt+KcKlLV1UFWJscUEBOLUqAhSsJ7ulYW+tPZSYSQ9iRz4abW9LQ1oQTqqGZn9
         Ejl8TgioygsdIWQNXfHgnGPGtW88SjQNosN1kZrsbuJ5ZKPpygLVIYEbmVPLrT+DhrSQ
         V4fSBEW+/jx3ZFfoz9gPpHxYiPTHSUPNdfyQPjlBNgqoc/nskguVSEukkNmYt7rj+IDY
         cp5mDEUF1bMkkGi89kKb7BZ87FRWFMnMs5HBXhxS4hdtImZUkLqQs8aBBJR3tG9t+Xpj
         PW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0WCBbKlN3H2RLMXFyw7xfGn8ug6YqjVteAv3Iz89Go=;
        b=m1uOXM2tf2HNxkyNfh6o5sywkEVDf6RztHW8MO/lCET4+LXE45jFNHKQP2GAuhiW+R
         5IPKn4nlM/C7Fhu5aQLoCRu6RxAZM7P+1pVRYV+sq/nK4B/pRw2Dhsf4IK2pGnTxFn2M
         /fT0BU9Jinpn8aS+LghUibEc0Af6SCddUb+cf5x4GhTVcoukYQZRtLLGPusccSVayeZQ
         MeZpilNPGEzhK4/gpu0QHxmHOKCz8FqAtlsOhTtZu6ors+kVAPs9EacgjMqCaSamQkio
         0VDBBGNjXZLOj0+wRieSYGvj9ulqLpsTLbvtlDtDligzsrLXra1CeBOEkjLnhJY2eqE0
         JMEA==
X-Gm-Message-State: AOAM531Jgof8wzIoZo0CDeRJ680SDDPQbhGfDp4vIphto4lr/6k546aN
        hJHJbgVMaiCBpI41PW68LgQ9rpXghf8=
X-Google-Smtp-Source: ABdhPJzhGk/apyuUOFJO6BzMUHyvCz3QlCOAX63h65V9ueRQAu4EzZWL/Hg9pGwHI1YNJpxt9pWVnw==
X-Received: by 2002:a17:90b:1495:: with SMTP id js21mr6000385pjb.48.1591723597857;
        Tue, 09 Jun 2020 10:26:37 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id w190sm10390387pfw.35.2020.06.09.10.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 10:26:36 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com, toke@redhat.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: [RFC PATCH bpf-next 0/2] bpf_redirect_map() tail call detection and xdp_do_redirect() avoidance
Date:   Tue,  9 Jun 2020 19:26:20 +0200
Message-Id: <20200609172622.37990-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I hacked a quick PoC, based on the input from my earlier post [1].

Quick recap; For certain XDP programs, would it be possible to get rid
of the xdp_do_redirect() call (and the per-cpu write/read), and
instead perform the action directly from the BPF helper? If so, that
would potentially make the XDP_REDIRECT faster/less complex.

This PoC/RFC teach the verifier to detect when an XDP program is
structured such that all bpf_redirect_map() calls are tail calls. A
driver can then probe the BPF program, use the new
xdp_set_redirect_tailcall() function, and avoid the xdp_do_redirect()
call. This was Toke's suggestion, instead of my XDP_CONSUMED idea,
adding a new action.

To perform the xdp_do_redirect() tasks from the bpf_redirect_map()
helper, additional parameters are needed (XDP context, netdev, and XDP
program). They are passed via the bpf_redirect_into per-cpu structure
using the xdp_set_redirect_tailcall() function.

Note that the code is broken for programs mixing bpf_redirect() and
bpf_redirect_map()!

There are more details in the commits.

Is this a good idea? I have only measured for AF_XDP redirects, but
all XDP_REDIRECT targets should benefit. For AF_XDP the rxdrop
scenario went from 21.5 to 23.2 Mpps on my machine.

Next steps would be implement proper tail calls (suggested by John and
Alexei).

Getting input on my (horrible) verifier peephole hack, and a better
way to detect tail calls would be very welcome!

Disregard naming and style. I'm mostly interested what people think
about the concept, and if it's worth working on.

Next steps:
  * Better tail call detection in the verifier, instead of the naive
    peephole version in patch 1.
  * Implement proper tail calls (constrained, indirect jump BPF
    instruction).


Cheers,
Björn

[1] https://lore.kernel.org/bpf/CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com/

Björn Töpel (2):
  bpf, xdp: add naive bpf_redirect_map() tail call detection
  i40e: avoid xdp_do_redirect() call when "redirect_tail_call" is set

 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 14 ++++-
 include/linux/bpf_verifier.h                |  2 +
 include/linux/filter.h                      | 19 ++++++-
 kernel/bpf/verifier.c                       | 53 +++++++++++++++++++
 net/core/filter.c                           | 57 +++++++++++++++++++++
 6 files changed, 154 insertions(+), 5 deletions(-)


base-commit: cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2
-- 
2.25.1

