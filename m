Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D1696241
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjBNLUG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 06:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjBNLT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:19:59 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B090913505
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 03:19:55 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-FLWRN19fNa-K5-TYwAuV4Q-1; Tue, 14 Feb 2023 06:19:36 -0500
X-MC-Unique: FLWRN19fNa-K5-TYwAuV4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9EF51C05149;
        Tue, 14 Feb 2023 11:19:35 +0000 (UTC)
Received: from hog.localdomain (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5475B40C945A;
        Tue, 14 Feb 2023 11:19:33 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Date:   Tue, 14 Feb 2023 12:17:37 +0100
Message-Id: <cover.1676052788.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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


Changes in v2
use reverse xmas tree ordering in tls_set_sw_offload and
do_tls_setsockopt_conf
turn the alt_crypto_info into an else if
selftests: add rekey_fail test

Vadim suggested simplifying tls_set_sw_offload by copying the new
crypto_info in the context in do_tls_setsockopt_conf, and then
detecting the rekey in tls_set_sw_offload based on whether the iv was
already set, but I don't think we can have a common error path
(otherwise we'd free the aead etc on rekey failure). I decided instead
to reorganize tls_set_sw_offload so that the context is unmodified
until we know the rekey cannot fail. Some fields will be touched
during the rekey, but they will be set to the same value they had
before the rekey (prot->rec_seq_size, etc).

Apoorv suggested to name the struct tls_crypto_info_keys "tls13"
rather than "tls12". Since we're using the same crypto_info data for
TLS1.3 as for 1.2, even if the tests only run for TLS1.3, I'd rather
keep the "tls12" name, in case we end up adding a
"tls13_crypto_info_aes_gcm_128" type in the future.

Kuniyuki and Apoorv also suggested preventing rekeys on RX when we
haven't received a matching KeyUpdate message, but I'd rather let
userspace handle this and have a symmetric API between TX and RX on
the kernel side. It's a bit of a foot-gun, but we can't really stop a
broken userspace from rolling back the rec_seq on an existing
crypto_info either, and that seems like a worse possible breakage.

Sabrina Dubroca (5):
  tls: remove tls_context argument from tls_set_sw_offload
  tls: block decryption when a rekey is pending
  tls: implement rekey for TLS1.3
  selftests: tls: add key_generation argument to tls_crypto_info_init
  selftests: tls: add rekey tests

 include/net/tls.h                 |   4 +
 net/tls/tls.h                     |   3 +-
 net/tls/tls_device.c              |   2 +-
 net/tls/tls_main.c                |  37 +++-
 net/tls/tls_sw.c                  | 189 +++++++++++++----
 tools/testing/selftests/net/tls.c | 336 +++++++++++++++++++++++++++++-
 6 files changed, 511 insertions(+), 60 deletions(-)

-- 
2.38.1

