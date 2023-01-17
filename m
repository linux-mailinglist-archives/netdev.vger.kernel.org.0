Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA566DF37
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjAQNrf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Jan 2023 08:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjAQNr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:47:26 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BCF1D90A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:47:24 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-4gsrSIJ7OHCzg8qtaFJd1w-1; Tue, 17 Jan 2023 08:47:21 -0500
X-MC-Unique: 4gsrSIJ7OHCzg8qtaFJd1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CFFB8030CC;
        Tue, 17 Jan 2023 13:47:21 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E241440C6EC4;
        Tue, 17 Jan 2023 13:47:20 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Frantisek Krenzelok <fkrenzel@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Date:   Tue, 17 Jan 2023 14:45:26 +0100
Message-Id: <cover.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
[1]). A sender transmits a KeyUpdate message and then changes its TX
key. The receiver should react by updating its RX key before
processing the next message.

This patchset implements key updates by:
 1. pausing decryption when a KeyUpdate message is received, to avoid
    attempting to use the old key to decrypt a record encrypted with
    the new key
 2. returning -EKEYEXPIRED to syscalls that cannot receive the
    KeyUpdate message, until the rekey has been performed by userspace
 3. passing the KeyUpdate message to userspace as a control message
 4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
    setsockopts

This API has been tested with gnutls to make sure that it allows
userspace libraries to implement key updates [2]. Thanks to Frantisek
Krenzelok <fkrenzel@redhat.com> for providing the implementation in
gnutls and testing the kernel patches.

Note: in a future series, I'll clean up tls_set_sw_offload and
eliminate the per-cipher copy-paste using tls_cipher_size_desc.

[1] https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3
[2] https://gitlab.com/gnutls/gnutls/-/merge_requests/1625

Sabrina Dubroca (5):
  tls: remove tls_context argument from tls_set_sw_offload
  tls: block decryption when a rekey is pending
  tls: implement rekey for TLS1.3
  selftests: tls: add key_generation argument to tls_crypto_info_init
  selftests: tls: add rekey tests

 include/net/tls.h                 |   4 +
 net/tls/tls.h                     |   3 +-
 net/tls/tls_device.c              |   2 +-
 net/tls/tls_main.c                |  32 +++-
 net/tls/tls_sw.c                  | 169 +++++++++++++++----
 tools/testing/selftests/net/tls.c | 272 +++++++++++++++++++++++++++++-
 6 files changed, 434 insertions(+), 48 deletions(-)

-- 
2.38.1

