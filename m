Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DA8674D82
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 07:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjATGvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 01:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjATGvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 01:51:50 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7138276B4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 22:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674197509; x=1705733509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vM7pJX+PgpNVcYQ8QtBHiplBZpIJvbkRyxVSXnZFusE=;
  b=rx3aortAJyevKaWwgdqvntsudVOj3xd7VbBAlIaYnTAOO9rzV8fabP+u
   uXxJcoN45Vg4IXt67VQvO5D1FopO3ul0Fo72js0AXaRnBNobFGu+TX2kh
   PTvqBm/30BXebWtb0muN16fSQyiy1PM1gNSqyW4X8akzzLSTKWmbAz7Hk
   0=;
X-IronPort-AV: E=Sophos;i="5.97,231,1669075200"; 
   d="scan'208";a="173102072"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 06:51:49 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id B3265A2D03;
        Fri, 20 Jan 2023 06:51:48 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 20 Jan 2023 06:51:48 +0000
Received: from bcd0741e4041.ant.amazon.com (10.43.160.120) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Fri, 20 Jan 2023 06:51:48 +0000
From:   Apoorv Kothari <apoorvko@amazon.com>
To:     <sd@queasysnail.net>
CC:     <fkrenzel@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 5/5] selftests: tls: add rekey tests
Date:   Thu, 19 Jan 2023 22:51:42 -0800
Message-ID: <20230120065142.78346-1-apoorvko@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <803aee7cbc1321a06795ec194685931d6aeec53d.1673952268.git.sd@queasysnail.net>
References: <803aee7cbc1321a06795ec194685931d6aeec53d.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
 EX19D030UWB003.ant.amazon.com (10.13.139.142)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  tools/testing/selftests/net/tls.c | 258 ++++++++++++++++++++++++++++++
>  1 file changed, 258 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 5f3adb28fee1..97c20e2246e1 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -1453,6 +1453,264 @@ TEST_F(tls, shutdown_reuse)
>      EXPECT_EQ(errno, EISCONN);
>  }
>  
> +#define TLS_RECORD_TYPE_HANDSHAKE      0x16
> +/* key_update, length 1, update_not_requested */
> +static const char key_update_msg[] = "\x18\x00\x00\x01\x00";
> +static void tls_send_keyupdate(struct __test_metadata *_metadata, int fd)
> +{
> +    size_t len = sizeof(key_update_msg);
> +
> +    EXPECT_EQ(tls_send_cmsg(fd, TLS_RECORD_TYPE_HANDSHAKE,
> +                (char *)key_update_msg, len, 0),
> +          len);
> +}
> +
> +static void tls_recv_keyupdate(struct __test_metadata *_metadata, int fd, int flags)
> +{
> +    char buf[100];
> +
> +    EXPECT_EQ(tls_recv_cmsg(_metadata, fd, TLS_RECORD_TYPE_HANDSHAKE, buf, sizeof(buf), flags),
> +          sizeof(key_update_msg));
> +    EXPECT_EQ(memcmp(buf, key_update_msg, sizeof(key_update_msg)), 0);
> +}
> +
> +/* set the key to 0 then 1 for RX, immediately to 1 for TX */
> +TEST_F(tls_basic, rekey_rx)
> +{
> +    struct tls_crypto_info_keys tls12_0, tls12_1;

nit: Did you mean tls13_0 and tls13_1? There are also a few others in this patch.

> +    char const *test_str = "test_message";
> +    int send_len = strlen(test_str) + 1;
> +    char buf[20];
> +    int ret;
> +
> +    if (self->notls)
> +        return;
> +
> +    tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
> +                 &tls12_0, 0);
> +    tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
> +                 &tls12_1, 1);
> +
> +
> +    ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_1, tls12_1.len);
> +    ASSERT_EQ(ret, 0);
> +
> +    ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_0, tls12_0.len);
> +    ASSERT_EQ(ret, 0);
> +
> +    ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_1, tls12_1.len);
> +    EXPECT_EQ(ret, 0);
> +
> +    EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
> +    EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
> +}
> +
> +/* set the key to 0 then 1 for TX, immediately to 1 for RX */
> +TEST_F(tls_basic, rekey_tx)
> +{
> +    struct tls_crypto_info_keys tls12_0, tls12_1;
> +    char const *test_str = "test_message";
> +    int send_len = strlen(test_str) + 1;
> +    char buf[20];
> +    int ret;
> +
> +    if (self->notls)
> +        return;
> +
> +    tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
> +                 &tls12_0, 0);
> +    tls_crypto_info_init(TLS_1_3_VERSION, TLS_CIPHER_AES_GCM_128,
> +                 &tls12_1, 1);
> +
> +
> +    ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_0, tls12_0.len);
> +    ASSERT_EQ(ret, 0);
> +
> +    ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_1, tls12_1.len);
> +    ASSERT_EQ(ret, 0);
> +
> +    ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_1, tls12_1.len);
> +    EXPECT_EQ(ret, 0);
> +
> +    EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
> +    EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
> +}
> +
> +TEST_F(tls, rekey)
> +{
> +    char const *test_str_1 = "test_message_before_rekey";
> +    char const *test_str_2 = "test_message_after_rekey";
> +    struct tls_crypto_info_keys tls12;
> +    int send_len;
> +    char buf[100];
> +
> +    if (variant->tls_version != TLS_1_3_VERSION)
> +        return;
> +
> +    /* initial send/recv */
> +    send_len = strlen(test_str_1) + 1;
> +    EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
> +    EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
> +
> +    /* update TX key */
> +    tls_send_keyupdate(_metadata, self->fd);
> +    tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
> +    EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
> +
> +    /* send after rekey */
> +    send_len = strlen(test_str_2) + 1;
> +    EXPECT_EQ(send(self->fd, test_str_2, send_len, 0), send_len);
> +
> +    /* can't receive the KeyUpdate without a control message */
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
> +
> +    /* get KeyUpdate */
> +    tls_recv_keyupdate(_metadata, self->cfd, 0);
> +
> +    /* recv blocking -> -EKEYEXPIRED */
> +    EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), 0), -1);
> +    EXPECT_EQ(errno, EKEYEXPIRED);
> +
> +    /* recv non-blocking -> -EKEYEXPIRED */
> +    EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_DONTWAIT), -1);
> +    EXPECT_EQ(errno, EKEYEXPIRED);
> +
> +    /* update RX key */
> +    EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
> +
> +    /* recv after rekey */
> +    EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
> +    EXPECT_EQ(memcmp(buf, test_str_2, send_len), 0);
> +}
> +
> +TEST_F(tls, rekey_peek)
> +{
> +    char const *test_str_1 = "test_message_before_rekey";
> +    struct tls_crypto_info_keys tls12;
> +    int send_len;
> +    char buf[100];
> +
> +    if (variant->tls_version != TLS_1_3_VERSION)
> +        return;
> +
> +    send_len = strlen(test_str_1) + 1;
> +    EXPECT_EQ(send(self->fd, test_str_1, send_len, 0), send_len);
> +
> +    /* update TX key */
> +    tls_send_keyupdate(_metadata, self->fd);
> +    tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
> +    EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
> +
> +    EXPECT_EQ(recv(self->cfd, buf, sizeof(buf), MSG_PEEK), send_len);
> +    EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
> +
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, 0), send_len);
> +    EXPECT_EQ(memcmp(buf, test_str_1, send_len), 0);
> +
> +    /* can't receive the KeyUpdate without a control message */
> +    EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_PEEK), -1);
> +
> +    /* peek KeyUpdate */
> +    tls_recv_keyupdate(_metadata, self->cfd, MSG_PEEK);
> +
> +    /* get KeyUpdate */
> +    tls_recv_keyupdate(_metadata, self->cfd, 0);
> +
> +    /* update RX key */
> +    EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
> +}
> +
> +TEST_F(tls, splice_rekey)
> +{
> +    int send_len = TLS_PAYLOAD_MAX_LEN / 2;
> +    char mem_send[TLS_PAYLOAD_MAX_LEN];
> +    char mem_recv[TLS_PAYLOAD_MAX_LEN];
> +    struct tls_crypto_info_keys tls12;
> +    int p[2];
> +
> +    if (variant->tls_version != TLS_1_3_VERSION)
> +        return;
> +
> +    memrnd(mem_send, sizeof(mem_send));
> +
> +    ASSERT_GE(pipe(p), 0);
> +    EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
> +
> +    /* update TX key */
> +    tls_send_keyupdate(_metadata, self->fd);
> +    tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
> +    EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
> +
> +    EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
> +
> +    EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), send_len);
> +    EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
> +    EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
> +
> +    /* can't splice the KeyUpdate */
> +    EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), -1);
> +    EXPECT_EQ(errno, EINVAL);
> +
> +    /* peek KeyUpdate */
> +    tls_recv_keyupdate(_metadata, self->cfd, MSG_PEEK);
> +
> +    /* get KeyUpdate */
> +    tls_recv_keyupdate(_metadata, self->cfd, 0);
> +
> +    /* can't splice before updating the key */
> +    EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), -1);
> +    EXPECT_EQ(errno, EKEYEXPIRED);
> +
> +    /* update RX key */
> +    EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
> +
> +    EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, TLS_PAYLOAD_MAX_LEN, 0), send_len);
> +    EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
> +    EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
> +}
> +
> +TEST_F(tls, rekey_getsockopt)
> +{
> +    struct tls_crypto_info_keys tls12;
> +    struct tls_crypto_info_keys tls12_get;
> +    socklen_t len;
> +
> +    tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 0);
> +
> +    len = tls12.len;
> +    EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_get, &len), 0);
> +    EXPECT_EQ(len, tls12.len);
> +    EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
> +
> +    len = tls12.len;
> +    EXPECT_EQ(getsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_get, &len), 0);
> +    EXPECT_EQ(len, tls12.len);
> +    EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
> +
> +    if (variant->tls_version != TLS_1_3_VERSION)
> +        return;
> +
> +    tls_send_keyupdate(_metadata, self->fd);
> +    tls_crypto_info_init(variant->tls_version, variant->cipher_type, &tls12, 1);
> +    EXPECT_EQ(setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len), 0);
> +
> +    tls_recv_keyupdate(_metadata, self->cfd, 0);
> +    EXPECT_EQ(setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len), 0);
> +
> +    len = tls12.len;
> +    EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &tls12_get, &len), 0);
> +    EXPECT_EQ(len, tls12.len);
> +    EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
> +
> +    len = tls12.len;
> +    EXPECT_EQ(getsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12_get, &len), 0);
> +    EXPECT_EQ(len, tls12.len);
> +    EXPECT_EQ(memcmp(&tls12_get, &tls12, tls12.len), 0);
> +}
> +
>  FIXTURE(tls_err)
>  {
>      int fd, cfd;
> -- 
> 2.38.1

