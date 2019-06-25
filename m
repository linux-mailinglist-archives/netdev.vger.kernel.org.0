Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06E552D8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbfFYPGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:06:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33113 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfFYPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:06:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so18352948wru.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 08:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KKPHmmBOwXnHcguGeSbnRS60AUrWXa+mblZReIDBxc8=;
        b=jANMeXDEm+IQkcxcExpgTOW2IDCUcWHiRVWR+pZixb3GZi7Tmlx19p3Wb4JGFE5t7s
         T7bXMp+o2vO/sAixg3pTWaFdxro6WfZ4fVH0z3HXW/55rG/1L79KV7yMuvjiA9axbQ1k
         JRSCTq3TJER8fvV8GLJUz22THSkkecRgWyrKTQesPzBnVteozQjA/FQlhIjKVUw7t2FR
         1w+8rYKR6Cvj23fBoaatHaw3Sv3QfxeufCNt7A8x1wLRfxTTTQ1VR878wvrpI5MhFgND
         xxgcjJhicaTmSg8sqUpfZlsBsAYfJISgilNIrejqBOu9K3vHvJvNN1JiP6LmUi3Bnkyw
         Am7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KKPHmmBOwXnHcguGeSbnRS60AUrWXa+mblZReIDBxc8=;
        b=X6rn/ksvOOykLvGd6Pm3cMO75P8/Y4lqy/Gs6rlz9d4Pzw9OsaJCCJgajuuwTbILAQ
         iwxQTcA9zRnFXUzqi+IUlUZMp0KJpgi16Oy3dR2sbSkqKc75KUaL97YCDkxkPFw2r4zS
         o67hOcd1VQPXGkXlqIJxxYsVaaZ8Uu8VBEKBK1N5a84KPvHtciinwXXQTjgt18cwAFVM
         2HRmIuhdbJMjDkWoQcIY2Bowbng/OV4DOhfv3lvoQb2nvXNsXMsiWdN/qPR2wHVKwTgH
         kv5RsYieRbQQfVVUGR0HRNC8u0hV+nLr6Gf5OZp7i2ViNZ2goo7FupllvXyKGehe2ZJ4
         lisg==
X-Gm-Message-State: APjAAAW4h8vT+1P6pldNgB6AxjG09zgeGBLIviOZ7E+DbQqg9vSZRwHH
        +wRLmBWDfIiWbuYrPkPxhV4ykIyek8c=
X-Google-Smtp-Source: APXvYqwXnoK9CGunXEK6VpkcRvlmaN8Ij7kO+tylGljQ+B0QoODFMNpRWZwkxiZI45HiOUbuV1i4LA==
X-Received: by 2002:a5d:5303:: with SMTP id e3mr23598982wrv.239.1561475183133;
        Tue, 25 Jun 2019 08:06:23 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id r131sm1982108wmf.4.2019.06.25.08.06.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Jun 2019 08:06:22 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC, PATCH 0/2, net-next] net: netsec: Add XDP Support
Date:   Tue, 25 Jun 2019 18:06:17 +0300
Message-Id: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a respin of https://www.spinics.net/lists/netdev/msg526066.html
Since page_pool API fixes are merged into net-next we can now safely use 
it's DMA mapping capabilities. 

The first patch changes the buffer allocation from netdev_alloc_frag() 
to page_pool API. Although this will lead to slightly reduced performance 
(on raw packet drops only) we can use the API for XDP buffer recycling. 
Another side effect is a slight increase in memory usage, due to using a 
single page per packet.

The second patch adds XDP support on the driver. 
There's a bunch of interesting options that come up due to the single 
Tx queue.
Use of locking (to avoid messing up the Tx queue since ndo_xdp_xmit
and the normal stack can co-exist) is one thing. 
We also need to track down the 'buffer type' for TX and properly free or 
recycle the packet depending on it's nature. Since we use page_pool API in 
the XDP_TX case the buffers are already mapped for us and we only need to 
sync them, while on the ndo_xdp_xmit we need to map and send them

Ilias Apalodimas (2):
  net: netsec: Use page_pool API
  net: netsec: add XDP support

 drivers/net/ethernet/socionext/Kconfig  |   1 +
 drivers/net/ethernet/socionext/netsec.c | 459 ++++++++++++++++++++----
 2 files changed, 394 insertions(+), 66 deletions(-)

-- 
2.20.1

