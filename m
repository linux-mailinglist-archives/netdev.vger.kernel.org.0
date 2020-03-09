Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB2D17D890
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCIEQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:16:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIEQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:16:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00425158B5616;
        Sun,  8 Mar 2020 21:16:41 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:16:41 -0700 (PDT)
Message-Id: <20200308.211641.1162682781638307360.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     borisp@mellanox.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, kuba@kernel.org, secdev@chelsio.com,
        varun@chelsio.com
Subject: Re: [PATCH net-next v4 0/6] cxgb4/chcr: ktls tx ofld support on T6
 adapter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200307143608.13109-1-rohitm@chelsio.com>
References: <20200307143608.13109-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:16:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Sat,  7 Mar 2020 20:06:02 +0530

> This series of patches add support for kernel tls offload in Tx direction,
> over Chelsio T6 NICs. SKBs marked as decrypted will be treated as tls plain
> text packets and then offloaded to encrypt using network device (chelsio T6
> adapter).
> 
> This series is broken down as follows:
> 
> Patch 1 defines a new macro and registers tls_dev_add and tls_dev_del
> callbacks. When tls_dev_add gets called we send a connection request to
> our hardware and to make HW understand about tls offload. Its a partial
> connection setup and only ipv4 part is done.
> 
> Patch 2 handles the HW response of the connection request and then we
> request to update TCB and handle it's HW response as well. Also we save
> crypto key locally. Only supporting TLS_CIPHER_AES_GCM_128_KEY_SIZE.
> 
> Patch 3 handles tls marked skbs (decrypted bit set) and sends it to ULD for
> crypto handling. This code has a minimal portion of tx handler, to handle
> only one complete record per skb.
> 
> Patch 4 hanldes partial end part of records. Also added logic to handle
> multiple records in one single skb. It also adds support to send out tcp
> option(/s) if exists in skb. If a record is partial but has end part of a
> record, we'll fetch complete record and then only send it to HW to generate
> HASH on complete record.
> 
> Patch 5 handles partial first or middle part of record, it uses AES_CTR to
> encrypt the partial record. If we are trying to send middle record, it's
> start should be 16 byte aligned, so we'll fetch few earlier bytes from the
> record and then send it to HW for encryption.
> 
> Patch 6 enables ipv6 support and also includes ktls startistics.
> 
> v1->v2:
> - mark tcb state to close in tls_dev_del.
> - u_ctx is now picked from adapter structure.
> - clear atid in case of failure.
> - corrected ULP_CRYPTO_KTLS_INLINE value.
> - optimized tcb update using control queue.
> - state machine handling when earlier states received.
> - chcr_write_cpl_set_tcb_ulp  function is shifted to patch3.
> - un-necessary updating left variable.
> 
> v2->v3:
> - add empty line after variable declaration.
> - local variable declaration in reverse christmas tree ordering.
> 
> v3->v4:
> - replaced kfree_skb with dev_kfree_skb_any.
> - corrected error message reported by kbuild test robot <lkp@intel.com>
> - mss calculation logic.
> - correct place for Alloc skb check.
> - Replaced atomic_t with atomic64_t
> - added few more statistics counters.

Series applied, thank you.
