Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D520F6528E3
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiLTWVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiLTWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:20:56 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A779226FD
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:47 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id n5-20020a170902d2c500b00189e5b86fe2so9961594plc.16
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9Lkq4/A6zPieb8tRyXJZSCMrT+1yCsHBU9Tu08+BlM=;
        b=UecwM7rjmCJSMpS1ctcVIZhsSq7zIrzMBjWLLoncLJ0pnnkOxCPiNzeHP7lwlyEU7S
         N4XEBf3HNWQJU+QcbtseXWhtK9pefSrqhU5LLl4aQdioRhmM+o96zegIYXay1FERjFle
         9MhOnudncLKXuCF6AFO3quwZt1r4xh8kQKkAT47m8RVAQTXHyhZB//7nTrv5GhXC0xRN
         a+aVNziHSSLPDsI5PZxzwrsCPLrW0gzY5zNvZoL8l68E/S53OYTj6jJ7AR5sGpk+77RO
         8peUTZXTR9TtKwQANqQ5GOoyp76VRWZXr65aVDmwI+4JjcwHAhcH8JjD7/PCrv2OQYee
         VZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9Lkq4/A6zPieb8tRyXJZSCMrT+1yCsHBU9Tu08+BlM=;
        b=vfW+ohQeJ0OA4a5AeLbwpxYRqtvP0lSrcUCLZmoNQX03shqYB6KuUxOCkPaEW8Ub0S
         SyJk0iXAX4i97okzYbix7nGWfjJHsRTkNamj/WVaMg9LS1RxzT75wjYXJK/i8+nzEZUx
         u2ya/Ldko/KWO/E5qBP+UJENlRZcTFflIRsinQrMwNTfZkURtTN/b/Etuw6xMcfH4ZJ7
         MpGGFR4SwxdWy/ymmNus6g8cSJH6UPAFkoKieiQZbaB+oH+dAvMBpcXoNidkkL0kBZOe
         LH5nqJHHolb2bCPvOJnbnETpc1hAYr/jdVhru1DC7VyRl9BRyqop9C1NpIeP81KqK+gs
         KV8A==
X-Gm-Message-State: AFqh2krW9UbUhd1146WYeiYqSYkOQJbrsRdyPtmXTyqWzMv/n8HPzD4l
        BtvBC7FlyOZPth0Bj10OE+aipAM=
X-Google-Smtp-Source: AMrXdXsivygEcEwL+VAVuk0P0l8J3nETK6FPuBfFOMLnpKueW15/LKOHnObysKdaVDpQGRXkD/aLbS8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:870f:0:b0:57e:c08b:b7bc with SMTP id
 b15-20020aa7870f000000b0057ec08bb7bcmr1006220pfo.77.1671574847102; Tue, 20
 Dec 2022 14:20:47 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:20:27 -0800
In-Reply-To: <20221220222043.3348718-1-sdf@google.com>
Mime-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220222043.3348718-2-sdf@google.com>
Subject: [PATCH bpf-next v5 01/17] bpf: Document XDP RX metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document all current use-cases and assumptions.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/xdp-rx-metadata.rst | 107 +++++++++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..4ddcae33c336 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
    xfrm_proc
    xfrm_sync
    xfrm_sysctl
+   xdp-rx-metadata
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
new file mode 100644
index 000000000000..37e8192d9b60
--- /dev/null
+++ b/Documentation/networking/xdp-rx-metadata.rst
@@ -0,0 +1,107 @@
+===============
+XDP RX Metadata
+===============
+
+This document describes how an XDP program can access hardware metadata
+related to a packet using a set of helper functions, and how it can pass
+that metadata on to other consumers.
+
+General Design
+==============
+
+XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
+Every device driver that wishes to expose additional packet metadata can
+implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
+via ``XDP_METADATA_KFUNC_xxx``.
+
+Currently, the following kfuncs are supported. In the future, as more
+metadata is supported, this set will grow:
+
+- ``bpf_xdp_metadata_rx_timestamp`` returns a packet's RX timestamp
+- ``bpf_xdp_metadata_rx_hash`` returns a packet's RX hash
+
+The XDP program can use these kfuncs to read the metadata into stack
+variables for its own consumption. Or, to pass the metadata on to other
+consumers, an XDP program can store it into the metadata area carried
+ahead of the packet.
+
+Not all kfuncs have to be implemented by the device driver; when not
+implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
+
+Within the XDP frame, the metadata layout is as follows::
+
+  +----------+-----------------+------+
+  | headroom | custom metadata | data |
+  +----------+-----------------+------+
+             ^                 ^
+             |                 |
+   xdp_buff->data_meta   xdp_buff->data
+
+The XDP program can store individual metadata items into this data_meta
+area in whichever format it chooses. Later consumers of the metadata
+will have to agree on the format by some out of band contract (like for
+the AF_XDP use case, see below).
+
+AF_XDP
+======
+
+``AF_XDP`` use-case implies that there is a contract between the BPF program
+that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and the final
+consumer. Thus the BPF program manually allocates a fixed number of
+bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
+of kfuncs to populate it. The userspace ``XSK`` consumer computes
+``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
+
+Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
+
+  +----------+-----------------+------+
+  | headroom | custom metadata | data |
+  +----------+-----------------+------+
+                               ^
+                               |
+                        rx_desc->address
+
+XDP_PASS
+========
+
+This is the path where the packets processed by the XDP program are passed
+into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
+contents. Currently, every driver has custom kernel code to parse
+the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
+conversion, and the XDP metadata is not used by the kernel when building
+skbs. However, TC-BPF programs can access the XDP metadata area using
+the data_meta pointer.
+
+In the future, we'd like to support a case where an XDP program
+can override some of the metadata used for building skbs.
+
+bpf_redirect_map
+================
+
+``bpf_redirect_map`` can redirect the frame to a different device.
+Some devices (like virtual ethernet links) support running a second XDP
+program after the redirect. However, the final consumer doesn't have
+access to the original hardware descriptor and can't access any of
+the original metadata. The same applies to XDP programs installed
+into devmaps and cpumaps.
+
+This means that for redirected packets only custom metadata is
+currently supported, which has to be prepared by the initial XDP program
+before redirect. If the frame is eventually passed to the kernel, the
+skb created from such a frame won't have any hardware metadata populated
+in its skb. And if such a packet is later redirected into an ``XSK``,
+that will also only have access to the custom metadata.
+
+
+bpf_tail_call
+=============
+
+Adding programs that access metadata kfuncs to the ``BPF_MAP_TYPE_PROG_ARRAY``
+is currently not supported.
+
+Example
+=======
+
+See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
+``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
+BPF program that handles XDP metadata.
-- 
2.39.0.314.g84b9a713c41-goog

