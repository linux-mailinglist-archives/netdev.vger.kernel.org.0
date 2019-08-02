Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836C7EE7A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403892AbfHBIMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:12:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40554 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfHBIMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:12:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so35684614pgj.7;
        Fri, 02 Aug 2019 01:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=31JCFugsyrkPY0WQpfbxJAFwT3+5WL3UC1w2/jqMeYI=;
        b=feloDJKxqSST/NnKQ7OM5lbkjVjjL+z1d/4zWlgVYSmxy4dWKW0WEY6CttTcvRT93u
         yxbxQhT+a5aUVp3DMuQRhqsemXjzD2Y3ajKyf51PYK8Yf2PE19Wzg+Eu/GJIN8p9G9GD
         m1cej+xtbi5SQtJAKn2i0H1+jiUtioFGb1Sh2yM3lM8F+srkKYC6i+UnniWtgFVdxgHK
         uSMWLgI17/kAJgmYfpjMqGqdDoaXuD8/otIk8rMs9ZROqafqJQFhzl9/nyhY1dGvlvsZ
         ce39MG23lqQV2sEQduILHUOwZrwbjFq1ZV7uxe+CRotKUfl0C6EyNyn3wBNEie6k42e7
         wCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=31JCFugsyrkPY0WQpfbxJAFwT3+5WL3UC1w2/jqMeYI=;
        b=KYcXDwdcculRHFHxMxmp9dLGzxMthS4GrEQQIMi+WsC/z1HfHca8MsyC+3NMERvZJY
         vGyCerXDXTGTSMXW21c/nQs6HwcMp85q6OonUT1ILHwXK3ccq+J5EgYK6SNQ/KD881Ra
         1rqQmaLEg2P/OUOFedMRykeFwg/rmGa2nKj77WwJTFuQQoYbglzpTS0/sYWhHaHb9ChN
         gkYCpKMqyyC3BHloVJXsT7OCryUMArhLUoSqGjS9+/jLzODOoo4SNIEfFRIudlhzIVnF
         0zHnTRJxJXRkgBT54qcV/RgkWxcdNCVGv26BCxeNP4bjgnv37uzP7b3KeD2augrE1EF4
         mLTw==
X-Gm-Message-State: APjAAAUz4owPt+GGUTU7thF1yWJUJWVBYVITF6cDe0ucyT7nICtyfW70
        0YMGmNmg6SPr4GxfRM8kTrc=
X-Google-Smtp-Source: APXvYqz7UDTNYIAvxrFASzoZHOKnNcEuzafM7at68gtwidd94kfELAoCIYnfUN5O62Hphza+WP9uXg==
X-Received: by 2002:a17:90a:270f:: with SMTP id o15mr3174865pje.56.1564733532657;
        Fri, 02 Aug 2019 01:12:12 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id e5sm4054338pgt.91.2019.08.02.01.12.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:12:12 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        bruce.richardson@intel.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 0/2] net: xdp: XSKMAP improvements
Date:   Fri,  2 Aug 2019 10:11:52 +0200
Message-Id: <20190802081154.30962-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series (v4 and counting) add two improvements for the XSKMAP,
used by AF_XDP sockets.

1. Automatic cleanup when an AF_XDP socket goes out of scope/is
   released. Instead of require that the user manually clears the
   "released" state socket from the map, this is done
   automatically. Each socket tracks which maps it resides in, and
   remove itself from those maps at relase. A notable implementation
   change, is that the sockets references the map, instead of the map
   referencing the sockets. Which implies that when the XSKMAP is
   freed, it is by definition cleared of sockets.

2. The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flag on insert,
   which this patch addresses.

Daniel, I (hopefully...) addressed the issues you found in
[1]. Instead of popping the tracked map, it's simply read. Then, the
socket is removed iff it's the same socket, i.e. no updates has
occurred. There are some code comments in the xsk_delete_from_maps()
function as well.


Thanks,
Björn

[1] https://lore.kernel.org/bpf/2417e1ab-16fa-d3ed-564e-1a50c4cb6717@iogearbox.net/

v1->v2: Fixed deadlock and broken cleanup. (Daniel)
v2->v3: Rebased onto bpf-next
v3->v4: {READ, WRITE}_ONCE consistency. (Daniel)
        Socket release/map update race. (Daniel)

Björn Töpel (2):
  xsk: remove AF_XDP socket from map when the socket is released
  xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP

 include/net/xdp_sock.h |  18 ++++++
 kernel/bpf/xskmap.c    | 130 ++++++++++++++++++++++++++++++++++-------
 net/xdp/xsk.c          |  48 +++++++++++++++
 3 files changed, 175 insertions(+), 21 deletions(-)

-- 
2.20.1

