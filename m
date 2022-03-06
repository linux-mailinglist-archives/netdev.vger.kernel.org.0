Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF74CEEA8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiCFXoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiCFXoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:08 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75E83F899;
        Sun,  6 Mar 2022 15:43:15 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id n2so2779424plf.4;
        Sun, 06 Mar 2022 15:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZYskkyWdZNMOfeFoxXmmlt0GkcdMqpx6aIgLqNBz8VA=;
        b=ANhDs1LFDYHShV+n6aqheE+4QsxLoqNNzpFdRpLa9LwutWjgpXxhO/GMvgfO493TU+
         M7Hx4fwdKuTU248LjFF2CE6fyB6TWAn8jeCT1jpYoQY45NkdP+BQ2MfUOO58/QYx1gtJ
         ipvCDOzgULN3xZU4/fPsoumYvS0C+a92Onnj/taD5ZGAw0fX9GNab0TmQQSI1ITXQO2l
         ORgQSEy6rJ/zbb56IpB+wlQoTkp07Hp7Wo+QCFgGIeZDtLxBa7PkGItXHdeNpeIB/DBn
         2Rm4vZLqb1b48NVXLMh5MuMKCtA2vCe4hM45Tr3mDfZA0vLWOUR8vB1/luRbcOYloRuj
         AGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZYskkyWdZNMOfeFoxXmmlt0GkcdMqpx6aIgLqNBz8VA=;
        b=eY2kPKqU1JEFqtR4YvOHiP18OhfY2+v1F8IrOhUoJZNGDxYUIK0HgLQG9nKvUP/If2
         6QiKVbXmV5ngWzTv+4YetDIReg24mXRDHJoEAqvlEIgDtofGiH3+/0BZw6gKIYnv4rDF
         Zdc8pSbIAQErFbye0DaOp/COy0qCgTVnrdwx+iMrc4y2MNZl9yB+cv4Jp0LHq8cC40zq
         Gi8EXUezqHnPtvwlg+E6VFmg3noC5QE3fQFNlbw7PvapRcBE+L0S1FFNVzyQr6LSa+U6
         mGeY/PYM6UmFFAEztmtr1iR4VbtMq7VZYYLTLzyqN37QHUR6gpCf/kvzIIzqXpe1obZb
         LKNQ==
X-Gm-Message-State: AOAM532qRV9LXYJztXD6+qIYNe3C674iVeMteaS2VN/ozLPIyqSmP/U4
        yZ8Oamlcqb6udVxf3YusPJlov5v0Pl4=
X-Google-Smtp-Source: ABdhPJxc9NmNfvu03ZYZ65Pg/au5N9gfPUPOPz5xGxiPNENyzzIAun8ANENeghrCVjPUQ/fi3CXRFQ==
X-Received: by 2002:a17:902:d2c4:b0:151:d1ee:a627 with SMTP id n4-20020a170902d2c400b00151d1eea627mr8294469plc.59.1646610194674;
        Sun, 06 Mar 2022 15:43:14 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id k12-20020a056a00168c00b004e15818cda3sm14166225pfc.114.2022.03.06.15.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:14 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
Date:   Mon,  7 Mar 2022 05:13:06 +0530
Message-Id: <20220306234311.452206-1-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2564; h=from:subject; bh=C7jy12dXyHbQKxShlK8I/gKHHbtcJ/rjjo9IE2V5tDo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWnk0FurTk2oYl7B97ZE0D1WQbGQbmvt1Z+LexM /jyCHZyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFpwAKCRBM4MiGSL8RyhsBD/ 9hO2V9OGni4L8xRDG7jAV9dAt3NE9MBd9Fmfwt8rLf40IMdSOXYmdYRXGJdmKUEF6ehaLdKGMsliHi +VhQXqXBFpk4KWCbPo+U8pWsopQ6TGoWW9dZEbQKASk+HNHMYZMw0m5Et4o1FcP0Z4WRUescjqsjSq IE3BqqTPvUUp3Ex+JHb3u4d+aTMYEWNDm4PCaJbWIcK+ezLRngJtC9AwtTe4XSincihfOZQMwpZhqf QGWTP6L4PFgpoV/jU9DgWU+c42YYHcOfPMrtQYxBJYIVoPD1itolu72QoC7i1YE3dtegSGp8vAZ1y3 0BU9JNmDdPBMTusiXNNGLJ87fnd4Laph7i7ghd6nbvzV/kHB2SlD8an5jhYhyD54TxbTS/0KkzBeZa hA0t/2nh6GKJVeHuuS4e4Z5807aJUYNQaHM2iFfm6KZz3xru/VROrNBOKOKDN1OEgwgbsovlB3aCfY uoviJvb+2++hIdoq/Ra/Bs2cbUJg2O1EdLZq1422iSfd/Ik4Ub6cB8wWKsNGtrEUjo70HyTj/VufaL QOOtnaeRfV2cjrBI+4Zl3wRJvWiByKWbZZFUF8pw1OzQDt4p011IsqwjptMmqTN0fpjmgt80u2WLvu 3mVLwlOkFZ05yolQoDW2NMLQ7jZPlmIfEK2MhMkDHmCByy7Tee7ZSy4XkbOg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
returning a packet pointer with a fixed immutable range. This can be useful to
enable DPA without having to use memcpy (currently the case in
bpf_xdp_load_bytes and bpf_xdp_store_bytes).

The intended usage to read and write data for multi-buff XDP is:

	int err = 0;
	char buf[N];

	off &= 0xffff;
	ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
	if (unlikely(!ptr)) {
		if (err < 0)
			return XDP_ABORTED;
		err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
		if (err < 0)
			return XDP_ABORTED;
		ptr = buf;
	}
	...
	// Do some stores and loads in [ptr, ptr + N) region
	...
	if (unlikely(ptr == buf)) {
		err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
		if (err < 0)
			return XDP_ABORTED;
	}

Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
it is also more meaningful to the user to see return value as R0=pkt.

This series is meant to collect feedback on the approach, next version can
include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
hooks, and explore not resetting range to zero on r0 += rX, instead check access
like check_mem_region_access (var_off + off < range), since there would be no
data_end to compare against and obtain a new range.

The common name and func_id is supposed to allow writing generic code using
bpf_packet_pointer that works for both XDP and TC programs.

Please see the individual patches for implementation details.

Kumar Kartikeya Dwivedi (5):
  bpf: Add ARG_SCALAR and ARG_CONSTANT
  bpf: Introduce pkt_uid concept for PTR_TO_PACKET
  bpf: Introduce bpf_packet_pointer helper to do DPA
  selftests/bpf: Add verifier tests for pkt pointer with pkt_uid
  selftests/bpf: Update xdp_adjust_frags to use bpf_packet_pointer

 include/linux/bpf.h                           |   4 +
 include/linux/bpf_verifier.h                  |   9 +-
 include/uapi/linux/bpf.h                      |  12 ++
 kernel/bpf/verifier.c                         |  97 ++++++++++--
 net/core/filter.c                             |  48 +++---
 tools/include/uapi/linux/bpf.h                |  12 ++
 .../bpf/prog_tests/xdp_adjust_frags.c         |  46 ++++--
 .../bpf/progs/test_xdp_update_frags.c         |  46 ++++--
 tools/testing/selftests/bpf/verifier/xdp.c    | 146 ++++++++++++++++++
 9 files changed, 358 insertions(+), 62 deletions(-)

-- 
2.35.1

