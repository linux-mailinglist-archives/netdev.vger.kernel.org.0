Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE558F5D4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiHKCXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiHKCXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE56B8FD46;
        Wed, 10 Aug 2022 19:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F925B81EFB;
        Thu, 11 Aug 2022 02:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B2FC433B5;
        Thu, 11 Aug 2022 02:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660184592;
        bh=dw+R3u/B+bMoQSJiFOsepa+6s3d8d0zegVEzAFwaBtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQKexM6TZ7MnYi8OHAjCTK3l/eyTJJuWjIBxy76RFBjNo1Ag7IkM0ENAnIWe9Osxi
         H4Mv2psQnrDzCp2Te7n/p9lqQ2TAW75yb3tn+0/MOK4RI1b/umOZTG/wWxPcc2XKA9
         x5by4MhoUjwEFW8ZB6n45fKM3pQa6JscRZObCrz9shTo/C0AzlILYd+9Z/HFZcQw66
         /R4MJH+fS9WvGU0G/vBxRkF8BbUN+/iZQAletNLeIv1kFQcXEABiJn+gJQnzJN3F1j
         hfCBwu1g45+Da03kBKJPKNsyWa/jGIzH7iO9ZmQDOLuTLYngahzOPVNUSq3ez5/aM/
         Adzad3mr3vDEg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 3/4] ynl: add a sample python library
Date:   Wed, 10 Aug 2022 19:23:03 -0700
Message-Id: <20220811022304.583300-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A very short and very incomplete generic python library.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/samples/ynl.py | 342 +++++++++++++++++++++++++++++++++++
 1 file changed, 342 insertions(+)
 create mode 100644 tools/net/ynl/samples/ynl.py

diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/samples/ynl.py
new file mode 100644
index 000000000000..59c178e063f1
--- /dev/null
+++ b/tools/net/ynl/samples/ynl.py
@@ -0,0 +1,342 @@
+# SPDX-License-Identifier: BSD-3-Clause
+
+import functools
+import jsonschema
+import random
+import socket
+import struct
+import yaml
+
+#
+# Generic Netlink code which should really be in some library, but I can't quickly find one.
+#
+
+
+class Netlink:
+    SOL_NETLINK = 270
+
+    NETLINK_CAP_ACK = 10
+
+    NLMSG_ERROR = 2
+    NLMSG_DONE = 3
+
+    NLM_F_REQUEST = 1
+    NLM_F_ACK = 4
+    NLM_F_ROOT = 0x100
+    NLM_F_MATCH = 0x200
+    NLM_F_APPEND = 0x800
+
+    NLM_F_DUMP = NLM_F_ROOT | NLM_F_MATCH
+
+    NLA_F_NESTED = 0x8000
+    NLA_F_NET_BYTEORDER = 0x4000
+
+    NLA_TYPE_MASK = NLA_F_NESTED | NLA_F_NET_BYTEORDER
+
+    # Genetlink defines
+    NETLINK_GENERIC = 16
+
+    GENL_ID_CTRL = 0x10
+
+    # nlctrl
+    CTRL_CMD_GETFAMILY = 3
+
+    CTRL_ATTR_FAMILY_ID = 1
+    CTRL_ATTR_FAMILY_NAME = 2
+
+
+class NlAttr:
+    def __init__(self, raw, offset):
+        self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
+        self.type = self._type & ~Netlink.NLA_TYPE_MASK
+        self.payload_len = self._len
+        self.full_len = (self.payload_len + 3) & ~3
+        self.raw = raw[offset + 4:offset + self.payload_len]
+
+    def as_u16(self):
+        return struct.unpack("H", self.raw)[0]
+
+    def as_u32(self):
+        return struct.unpack("I", self.raw)[0]
+
+    def as_strz(self):
+        return self.raw.decode('ascii')[:-1]
+
+    def __repr__(self):
+        return f"[type:{self.type} len:{self._len}] {self.raw}"
+
+
+class NlAttrs:
+    def __init__(self, msg):
+        self.attrs = []
+
+        offset = 0
+        while offset < len(msg):
+            attr = NlAttr(msg, offset)
+            offset += attr.full_len
+            self.attrs.append(attr)
+
+    def __iter__(self):
+        yield from self.attrs
+
+
+class NlMsg:
+    def __init__(self, msg, offset):
+        self.hdr = msg[offset:offset + 16]
+
+        self.nl_len, self.nl_type, self.nl_flags, self.nl_seq, self.nl_portid = \
+            struct.unpack("IHHII", self.hdr)
+
+        self.raw = msg[offset + 16:offset + self.nl_len]
+
+        self.error = 0
+        self.done = 0
+
+        if self.nl_type == Netlink.NLMSG_ERROR:
+            self.error = struct.unpack("i", self.raw[0:4])[0]
+            self.done = 1
+        elif self.nl_type == Netlink.NLMSG_DONE:
+            self.done = 1
+
+    def __repr__(self):
+        msg = f"nl_len = {self.nl_len} nl_flags = 0x{self.nl_flags:x} nl_type = {self.nl_type}\n"
+        if self.error:
+            msg += '\terror: ' + str(self.error)
+        return msg
+
+
+class NlMsgs:
+    def __init__(self, data):
+        self.msgs = []
+
+        offset = 0
+        while offset < len(data):
+            msg = NlMsg(data, offset)
+            offset += msg.nl_len
+            self.msgs.append(msg)
+
+    def __iter__(self):
+        yield from self.msgs
+
+
+genl_family_name_to_id = None
+
+
+def _genl_msg(nl_type, nl_flags, genl_cmd, genl_version):
+    # we prepend length in _genl_msg_finalize()
+    nlmsg = struct.pack("HHII", nl_type, nl_flags, random.randint(1, 1024), 0)
+    genlmsg = struct.pack("bbH", genl_cmd, genl_version, 0)
+    return nlmsg + genlmsg
+
+
+def _genl_msg_finalize(msg):
+    return struct.pack("I", len(msg) + 4) + msg
+
+
+def _genl_load_families():
+    with socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, Netlink.NETLINK_GENERIC) as sock:
+        sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_CAP_ACK, 1)
+
+        msg = _genl_msg(Netlink.GENL_ID_CTRL, Netlink.NLM_F_REQUEST | Netlink.NLM_F_ACK | Netlink.NLM_F_DUMP,
+                        Netlink.CTRL_CMD_GETFAMILY, 1)
+        msg = _genl_msg_finalize(msg)
+
+        sock.send(msg, 0)
+
+        global genl_family_name_to_id
+        genl_family_name_to_id = dict()
+
+        while True:
+            reply = sock.recv(128 * 1024)
+            nms = NlMsgs(reply)
+            for nl_msg in nms:
+                if nl_msg.error:
+                    print("Netlink error:", nl_msg.error)
+                    return
+                if nl_msg.done:
+                    return
+
+                gm = GenlMsg(nl_msg)
+                fam_id = None
+                fam_name = None
+                for attr in gm.raw_attrs:
+                    if attr.type == Netlink.CTRL_ATTR_FAMILY_ID:
+                        fam_id = attr.as_u16()
+                    elif attr.type == Netlink.CTRL_ATTR_FAMILY_NAME:
+                        fam_name = attr.as_strz()
+                if fam_id is not None and fam_name is not None:
+                    genl_family_name_to_id[fam_name] = fam_id
+
+
+class GenlMsg:
+    def __init__(self, nl_msg):
+        self.nl = nl_msg
+
+        self.hdr = nl_msg.raw[0:4]
+        self.raw = nl_msg.raw[4:]
+
+        self.genl_cmd, self.genl_version, _ = struct.unpack("bbH", self.hdr)
+
+        self.raw_attrs = NlAttrs(self.raw)
+
+    def __repr__(self):
+        msg = repr(self.nl)
+        msg += f"\tgenl_cmd = {self.genl_cmd} genl_ver = {self.genl_version}\n"
+        for a in self.raw_attrs:
+            msg += '\t\t' + repr(a) + '\n'
+        return msg
+
+
+class GenlFamily:
+    def __init__(self, family_name):
+        self.family_name = family_name
+
+        global genl_family_name_to_id
+        if genl_family_name_to_id is None:
+            _genl_load_families()
+
+        self.family_id = genl_family_name_to_id[family_name]
+
+#
+# YNL implementation details.
+#
+
+
+class YnlAttrSpace:
+    def __init__(self, family, yaml):
+        self.yaml = yaml
+
+        self.attrs = dict()
+        self.name = self.yaml['name']
+        self.name_prefix = self.yaml['name-prefix']
+        self.subspace_of = self.yaml['subspace-of'] if 'subspace-of' in self.yaml else None
+
+        val = 0
+        max_val = 0
+        for elem in self.yaml['attributes']:
+            if 'val' in elem:
+                val = elem['val']
+            else:
+                elem['val'] = val
+            if val > max_val:
+                max_val = val
+            val += 1
+
+            self.attrs[elem['name']] = elem
+
+        self.attr_list = [None] * (max_val + 1)
+        for elem in self.yaml['attributes']:
+            self.attr_list[elem['val']] = elem
+
+    def __getitem__(self, key):
+        return self.attrs[key]
+
+    def __contains__(self, key):
+        return key in self.yaml
+
+    def __iter__(self):
+        yield from self.attrs
+
+    def items(self):
+        return self.attrs.items()
+
+
+class YnlFamily:
+    def __init__(self, def_path, schema=None):
+        with open(def_path, "r") as stream:
+            self.yaml = yaml.safe_load(stream)
+
+        if schema:
+            with open(os.path.dirname(os.path.dirname(file_name)) + '/schema.yaml', "r") as stream:
+                schema = yaml.safe_load(stream)
+
+            jsonschema.validate(self.yaml, schema)
+
+        self.sock = socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, Netlink.NETLINK_GENERIC)
+        self.sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_CAP_ACK, 1)
+
+        self._ops = dict()
+        self._spaces = dict()
+
+        for elem in self.yaml['attribute-spaces']:
+            self._spaces[elem['name']] = YnlAttrSpace(self, elem)
+
+        async_separation = 'async-prefix' in self.yaml['operations']
+        val = 0
+        for elem in self.yaml['operations']['list']:
+            if not (async_separation and ('notify' in elem or 'event' in elem)):
+                if 'val' in elem:
+                    val = elem['val']
+                else:
+                    elem['val'] = val
+                val += 1
+
+            self._ops[elem['name']] = elem
+
+            bound_f = functools.partial(self._op, elem['name'])
+            setattr(self, elem['name'], bound_f)
+
+        self.family = GenlFamily(self.yaml['name'])
+
+    def _add_attr(self, space, name, value):
+        attr = self._spaces[space][name]
+        nl_type = attr['val']
+        if attr["type"] == 'nest':
+            nl_type |= Netlink.NLA_F_NESTED
+            attr_payload = b''
+            for subname, subvalue in value.items():
+                attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
+        elif attr["type"] == 'u32':
+            attr_payload = struct.pack("I", int(value))
+        elif attr["type"] == 'nul-string':
+            attr_payload = str(value).encode('ascii') + b'\x00'
+        else:
+            raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
+
+        pad = b'\x00' * ((4 - len(attr_payload) % 4) % 4)
+        return struct.pack('HH', len(attr_payload) + 4, nl_type) + attr_payload + pad
+
+    def _decode(self, attrs, space):
+        attr_space = self._spaces[space]
+        rsp = dict()
+        for attr in attrs:
+            attr_spec = attr_space.attr_list[attr.type]
+            if attr_spec["type"] == 'nest':
+                subdict = self._decode(NlAttrs(attr.raw), attr_spec['nested-attributes'])
+                rsp[attr_spec['name']] = subdict
+            elif attr_spec['type'] == 'u32':
+                rsp[attr_spec['name']] = attr.as_u32()
+            elif attr_spec["type"] == 'nul-string':
+                rsp[attr_spec['name']] = attr.as_strz()
+            else:
+                raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
+        return rsp
+
+    def _op(self, method, vals):
+        op = self._ops[method]
+
+        msg = _genl_msg(self.family.family_id, Netlink.NLM_F_REQUEST | Netlink.NLM_F_ACK,
+                        op['val'], 1)
+        for name, value in vals.items():
+            msg += self._add_attr(op['attribute-space'], name, value)
+        msg = _genl_msg_finalize(msg)
+
+        self.sock.send(msg, 0)
+
+        done = False
+        rsp = None
+        while not done:
+            reply = self.sock.recv(128 * 1024)
+            nms = NlMsgs(reply)
+            for nl_msg in nms:
+                if nl_msg.error:
+                    print("Netlink error:", nl_msg.error)
+                    return
+                if nl_msg.done:
+                    done = True
+                    break
+
+                gm = GenlMsg(nl_msg)
+                rsp = self._decode(gm.raw_attrs, op['attribute-space'])
+
+        return rsp
-- 
2.37.1

