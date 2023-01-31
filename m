Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4043268223A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjAaCeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjAaCe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCFC2FCFC;
        Mon, 30 Jan 2023 18:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D9C26137C;
        Tue, 31 Jan 2023 02:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A642C433EF;
        Tue, 31 Jan 2023 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132446;
        bh=FP9VwYK0ZdjVTX59IJGPo41hwyCqQagAWji2fisP754=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDS3r25CDO8FEeEs8f4HgHZzbc8+n8Wx+dOqQAMMpF9lOAsqChuPfKjzZgbR7+ytW
         mnOdhAxWm/HenjmDIPkR/khnI+S7NNHH4dFPlk1m3UP+RWW5LWDCLBdA1vXhTIKEcL
         bNtno+vIbhwfTaogoB8Gj+SKqxJAA2d9gNC0aGcMAChT1PeSBgHOoju8xiccYXyNCP
         Wn1FT41tKIS38HRzmExAbNT4X1+LoqP5ARS1iO9tNWaFrtwuM6dw4FcKyX+o2W+Bua
         wbThWoWAjOavZPVEEB/iDfHXUrFx2k/mwHgk1auBDZbIP1y7uFylDiGMq/ts09cKbq
         gDM7C2zZGZJ8A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 13/14] docs: netlink: add a starting guide for working with specs
Date:   Mon, 30 Jan 2023 18:33:53 -0800
Message-Id: <20230131023354.1732677-14-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a bit of documentation about the internals of Netlink
and the specs, but really the goal is for most people to not
worry about those. Add a practical guide for beginners who
want to poke at the specs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/userspace-api/netlink/index.rst |  1 +
 .../userspace-api/netlink/intro-specs.rst     | 80 +++++++++++++++++++
 Documentation/userspace-api/netlink/specs.rst |  3 +
 3 files changed, 84 insertions(+)
 create mode 100644 Documentation/userspace-api/netlink/intro-specs.rst

diff --git a/Documentation/userspace-api/netlink/index.rst b/Documentation/userspace-api/netlink/index.rst
index be250110c8f6..26f3720cb3be 100644
--- a/Documentation/userspace-api/netlink/index.rst
+++ b/Documentation/userspace-api/netlink/index.rst
@@ -10,6 +10,7 @@ Netlink documentation for users.
    :maxdepth: 2
 
    intro
+   intro-specs
    specs
    c-code-gen
    genetlink-legacy
diff --git a/Documentation/userspace-api/netlink/intro-specs.rst b/Documentation/userspace-api/netlink/intro-specs.rst
new file mode 100644
index 000000000000..a3b847eafff7
--- /dev/null
+++ b/Documentation/userspace-api/netlink/intro-specs.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+=====================================
+Using Netlink protocol specifications
+=====================================
+
+This document is a quick starting guide for using Netlink protocol
+specifications. For more detailed description of the specs see :doc:`specs`.
+
+Simple CLI
+==========
+
+Kernel comes with a simple CLI tool which should be useful when
+developing Netlink related code. The tool is implemented in Python
+and can use a YAML specification to issue Netlink requests
+to the kernel. Only Generic Netlink is supported.
+
+The tool is located at ``tools/net/ynl/cli.py``. It accepts
+a handul of arguments, the most important ones are:
+
+ - ``--spec`` - point to the spec file
+ - ``--do $name`` / ``--dump $name`` - issue request ``$name``
+ - ``--json $attrs`` - provide attributes for the request
+ - ``--subscribe $group`` - receive notifications from ``$group``
+
+YAML specs can be found under ``Documentation/netlink/specs/``.
+
+Example use::
+
+  $ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/ethtool.yaml \
+        --do rings-get \
+	--json '{"header":{"dev-index": 18}}'
+  {'header': {'dev-index': 18, 'dev-name': 'eni1np1'},
+   'rx': 0,
+   'rx-jumbo': 0,
+   'rx-jumbo-max': 4096,
+   'rx-max': 4096,
+   'rx-mini': 0,
+   'rx-mini-max': 4096,
+   'tx': 0,
+   'tx-max': 4096,
+   'tx-push': 0}
+
+The input arguments are parsed as JSON, while the output is only
+Python-pretty-printed. This is because some Netlink types can't
+be expressed as JSON directly. If such attributes are needed in
+the input some hacking of the script will be necessary.
+
+The spec and Netlink internals are factored out as a standalone
+library - it should be easy to write Python tools / tests reusing
+code from ``cli.py``.
+
+Generating kernel code
+======================
+
+``tools/net/ynl/ynl-regen.sh`` scans the kernel tree in search of
+auto-generated files which need to be updated. Using this tool is the easiest
+way to generate / update auto-generated code.
+
+By default code is re-generated only if spec is newer than the source,
+to force regeneration use ``-f``.
+
+``ynl-regen.sh`` searches for ``YNL-GEN`` in the contents of files
+(note that it only scans files in the git index, that is only files
+tracked by git!) For instance the ``fou_nl.c`` kernel source contains::
+
+  /*	Documentation/netlink/specs/fou.yaml */
+  /* YNL-GEN kernel source */
+
+``ynl-regen.sh`` will find this marker and replace the file with
+kernel source based on fou.yaml.
+
+The simplest way to generate a new file based on a spec is to add
+the two marker lines like above to a file, add that file to git,
+and run the regeneration tool. Grep the tree for ``YNL-GEN``
+to see other examples.
+
+The code generation itself is performed by ``tools/net/ynl/ynl-gen-c.py``
+but it takes a few arguments so calling it directly for each file
+quickly becomes tedious.
diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index 8394d74fc63a..6ffe8137cd90 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -21,6 +21,9 @@ kernel headers directly.
 
 YAML specifications can be found under ``Documentation/netlink/specs/``
 
+This document describes details of the schema.
+See :doc:`intro-specs` for a practical starting guide.
+
 Compatibility levels
 ====================
 
-- 
2.39.1

