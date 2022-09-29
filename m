Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3210D5EEAC5
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiI2BLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiI2BLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:11:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB18610FC60;
        Wed, 28 Sep 2022 18:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A185B822C8;
        Thu, 29 Sep 2022 01:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB590C43141;
        Thu, 29 Sep 2022 01:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664413893;
        bh=pCTwQnG0waXGny4KBnxP9TITWv2nGgx0dRQ5OSwpc9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqnFZFLWviaeXOzkAa5SxAgpc0340g1oBLwKASIkq9jYibHZwC8ZO2BMbs094bOZP
         BAGoIhASOXr2HeRmcr6KxuP8SA3sCQvCHvzJqyfgk5CEy9ixru5GR4Wc5K03SY3hlq
         RULEJaWEQFD9/u/ybWHpZg6F4IpW8swmGiLewkgtxs9hrRevRTEnCTQhuSCaX4Sn+m
         EgAQnkU+0mZzr8zvRHM6sxJuPywN6Cr/diQg15D1ZwAe0O3Itsxnpk/KYion0e/BrK
         kgM1FqIDi8E3nCKC8cIpGwpvs8cQQndR5YTl1RRfdyN+GZdDK0LMfwt3oIUAqPwp4e
         4sZMUwc8lNL+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] net: add basic C code generators for Netlink
Date:   Wed, 28 Sep 2022 18:11:19 -0700
Message-Id: <20220929011122.1139374-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929011122.1139374-1-kuba@kernel.org>
References: <20220929011122.1139374-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code generators to turn Netlink specs into C code.
I'm definitely not proud of it.

The main generator is in Python, there's a bash script
to regen all code-gen'ed files in tree after making
spec changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS                |    1 +
 tools/net/ynl/ynl-gen-c.py | 1998 ++++++++++++++++++++++++++++++++++++
 tools/net/ynl/ynl-regen.sh |   30 +
 3 files changed, 2029 insertions(+)
 create mode 100755 tools/net/ynl/ynl-gen-c.py
 create mode 100755 tools/net/ynl/ynl-regen.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 93b7b6000654..e03123d776cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14202,6 +14202,7 @@ F:	include/uapi/linux/netdevice.h
 F:	lib/net_utils.c
 F:	lib/random32.c
 F:	net/
+F:	tools/net/
 F:	tools/testing/selftests/net/
 
 NETWORKING [IPSEC]
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
new file mode 100755
index 000000000000..69800aecd45b
--- /dev/null
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -0,0 +1,1998 @@
+#!/usr/bin/env python
+
+import argparse
+import jsonschema
+import os
+import yaml
+
+
+def c_upper(name):
+    return name.upper().replace('-', '_')
+
+
+def c_lower(name):
+    return name.lower().replace('-', '_')
+
+
+class BaseNlLib:
+    def __init__(self):
+        pass
+
+    def get_family_id(self):
+        return 'ys->family_id'
+
+    def parse_cb_run(self, cb, data, is_dump=False, indent=1):
+        ind = '\n\t\t' + '\t' * indent + ' '
+        if is_dump:
+            return f"mnl_cb_run2(ys->rx_buf, len, 0, 0, {cb}, {data},{ind}ynl_cb_array, NLMSG_MIN_TYPE)"
+        else:
+            return f"mnl_cb_run2(ys->rx_buf, len, ys->seq, ys->portid,{ind}{cb}, {data},{ind}" + \
+                   "ynl_cb_array, NLMSG_MIN_TYPE)"
+
+
+class Type:
+    def __init__(self, family, attr_set, attr):
+        self.family = family
+        self.attr = attr
+        self.value = attr['value']
+        self.name = attr['name'].replace('-', '_')
+        self.type = attr['type']
+        self.checks = attr.get('checks', {})
+
+        if 'len' in attr:
+            self.len = attr['len']
+        if 'nested-attributes' in attr:
+            self.nested_attrs = attr['nested-attributes']
+            if self.nested_attrs == family.name:
+                self.nested_render_name = f"{family.name}"
+            else:
+                self.nested_render_name = f"{family.name}_{self.nested_attrs.replace('-', '_')}"
+
+        self.enum_name = f"{attr_set.name_prefix}{self.name}"
+        self.enum_name = self.enum_name.upper().replace('-', '_')
+        self.c_name = self.name.replace('-', '_')
+        if self.c_name in c_kw:
+            self.c_name += '_'
+
+    def __getitem__(self, key):
+        return self.attr[key]
+
+    def __contains__(self, key):
+        return key in self.attr
+
+    def is_multi_val(self):
+        return None
+
+    def is_scalar(self):
+        return self.type in {'u8', 'u16', 'u32', 'u64', 's32', 's64'}
+
+    def presence_type(self):
+        return 'bit'
+
+    def presence_member(self, space, type_filter):
+        if self.presence_type() != type_filter:
+            return
+
+        if self.presence_type() == 'bit':
+            pfx = '__' if space == 'user' else ''
+            return f"{pfx}u32 {self.c_name}:1;"
+
+        if self.presence_type() == 'len':
+            pfx = '__' if space == 'user' else ''
+            return f"{pfx}u32 {self.c_name}_len;"
+
+    def _complex_member_type(self, ri):
+        return None
+
+    def free_needs_iter(self):
+        return False
+
+    def free(self, ri, var, ref):
+        if self.is_multi_val() or self.presence_type() == 'len':
+            ri.cw.p(f'free({var}->{ref}{self.c_name});')
+
+    def arg_member(self, ri):
+        member = self._complex_member_type(ri)
+        if member:
+            return [member + ' *' + self.c_name]
+        raise Exception(f"Struct member not implemented for class type {self.type}")
+
+    def struct_member(self, ri):
+        if self.is_multi_val():
+            ri.cw.p(f"unsigned int n_{self.c_name};")
+        member = self._complex_member_type(ri)
+        if member:
+            ptr = ''
+            if self. is_multi_val():
+                ptr = '*'
+            ri.cw.p(f"{member} {ptr}{self.c_name};")
+            return
+        members = self.arg_member(ri)
+        for one in members:
+            ri.cw.p(one + ';')
+
+    def _attr_policy(self, policy):
+        return '{ .type = ' + policy + ', }'
+
+    def attr_policy(self, cw):
+        policy = 'NLA_' + self.attr['type'].upper()
+        policy = policy.replace('-', '_')
+
+        spec = self._attr_policy(policy)
+        cw.p(f"\t[{self.enum_name}] = {spec},")
+
+    def _attr_typol(self):
+        raise Exception(f"Type policy not implemented for class type {self.type}")
+
+    def attr_typol(self, cw):
+        typol = self._attr_typol()
+        cw.p(f'[{self.enum_name}] = {"{"} .name = "{self.name}", {typol}{"}"},')
+
+    def _attr_put_line(self, ri, var, line):
+        if self.presence_type() == 'bit':
+            ri.cw.p(f"if ({var}->_present.{self.c_name})")
+        elif self.presence_type() == 'len':
+            ri.cw.p(f"if ({var}->_present.{self.c_name}_len)")
+        ri.cw.p(f"{line};")
+
+    def _attr_put_simple(self, ri, var, put_type):
+        line = f"mnl_attr_put_{put_type}(nlh, {self.enum_name}, {var}->{self.c_name})"
+        self._attr_put_line(ri, var, line)
+
+    def attr_put(self, ri, var):
+        raise Exception(f"Put not implemented for class type {self.type}")
+
+    def _attr_get(self, ri, var):
+        raise Exception(f"Attr get not implemented for class type {self.type}")
+
+    def attr_get(self, ri, var, first):
+        lines, init_lines, local_vars = self._attr_get(ri, var)
+        if type(lines) is str:
+            lines = [lines]
+        if type(init_lines) is str:
+            init_lines = [init_lines]
+
+        kw = 'if' if first else 'else if'
+        ri.cw.block_start(line=f"{kw} (mnl_attr_get_type(attr) == {self.enum_name})")
+        if local_vars:
+            for local in local_vars:
+                ri.cw.p(local)
+            ri.cw.nl()
+
+        if not self.is_multi_val():
+            ri.cw.p(f"if (ynl_attr_validate(yarg, attr))")
+            ri.cw.p(f"return MNL_CB_ERROR;")
+            if self.presence_type() == 'bit':
+                ri.cw.p(f"{var}->_present.{self.c_name} = 1;")
+
+        if init_lines:
+            ri.cw.nl()
+            for line in init_lines:
+                ri.cw.p(line)
+
+        for line in lines:
+            ri.cw.p(line)
+        ri.cw.block_end()
+
+    def _setter_lines(self, ri, member, presence):
+        raise Exception(f"Setter not implemented for class type {self.type}")
+
+    def setter(self, ri, space, direction, deref=False, ref=None):
+        ref = (ref if ref else []) + [self.c_name]
+        var = "req"
+        member = f"{var}->{'.'.join(ref)}"
+
+        code = []
+        presence = ''
+        for i in range(0, len(ref)):
+            presence = f"{var}->{'.'.join(ref[:i] + [''])}_present.{ref[i]}"
+            if self.presence_type() == 'bit':
+                code.append(presence + ' = 1;')
+        code += self._setter_lines(ri, member, presence)
+
+        ri.cw.write_func('static inline void',
+                         f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}",
+                         body=code,
+                         args=[f'{type_name(ri, direction, deref=deref)} *{var}'] + self.arg_member(ri))
+
+
+class TypeUnused(Type):
+    def presence_type(self):
+        return ''
+
+    def _attr_typol(self):
+        return '.type = YNL_PT_REJECT, '
+
+    def attr_policy(self, cw):
+        pass
+
+class TypeScalar(Type):
+    def __init__(self, family, attr_set, attr):
+        super().__init__(family, attr_set, attr)
+
+        if 'enum' in self.attr:
+            self.type_name = f"enum {family.name}_{self.attr['enum'].replace('-', '_')}"
+        else:
+            self.type_name = '__' + self.type
+
+        self.byte_order_comment = ''
+        if 'byte-order' in attr:
+            self.byte_order_comment = f" /* {attr['byte-order']} */"
+
+    def _mnl_type(self):
+        t = self.type
+        # mnl does not have a helper for signed types
+        if t[0] == 's':
+            t = 'u' + t[1:]
+        return t
+
+    def _attr_policy(self, policy):
+        if 'flags-mask' in self.checks:
+            flags = self.family.consts[self.checks['flags-mask']]
+            flag_cnt = len(flags['entries'])
+            return f"NLA_POLICY_MASK({policy}, 0x{(1 << flag_cnt) - 1:x})"
+        elif 'enum' in self.attr:
+            enum = self.family.consts[self.attr['enum']]
+            cnt = len(enum['entries'])
+            return f"NLA_POLICY_MAX({policy}, {cnt})"
+        return super()._attr_policy(policy)
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_U{self.type[1:]}, '
+
+    def arg_member(self, ri):
+        return [f'{self.type_name} {self.c_name}{self.byte_order_comment}']
+
+    def attr_put(self, ri, var):
+        self._attr_put_simple(ri, var, self._mnl_type())
+
+    def _attr_get(self, ri, var):
+        return f"{var}->{self.c_name} = mnl_attr_get_{self._mnl_type()}(attr);", None, None
+
+    def _setter_lines(self, ri, member, presence):
+        return [f"{member} = {self.c_name};"]
+
+
+class TypeFlag(Type):
+    def arg_member(self, ri):
+        return []
+
+    def _attr_typol(self):
+        return '.type = YNL_PT_FLAG, '
+
+    def attr_put(self, ri, var):
+        self._attr_put_line(ri, var, f"mnl_attr_put(nlh, {self.enum_name}, 0, NULL)")
+
+    def _attr_get(self, ri, var):
+        return [], None, None
+
+    def _setter_lines(self, ri, member, presence):
+        return []
+
+
+class TypeString(Type):
+    def arg_member(self, ri):
+        return [f"const char *{self.c_name}"]
+
+    def presence_type(self):
+        return 'len'
+
+    def struct_member(self, ri):
+        ri.cw.p(f"char *{self.c_name};")
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_NUL_STR, '
+
+    def _attr_policy(self, policy):
+        mem = '{ .type = ' + policy
+        if 'max-len' in self.checks:
+            mem += ', .len = ' + str(self.checks['max-len'])
+        mem += ', }'
+        return mem
+
+    def attr_policy(self, cw):
+        if 'unterminated-ok' in self.checks and self.checks['unterminated-ok']:
+            policy = 'NLA_STRING'
+        else:
+            policy = 'NLA_NUL_STRING'
+
+        spec = self._attr_policy(policy)
+        cw.p(f"\t[{self.enum_name}] = {spec},")
+
+    def attr_put(self, ri, var):
+        self._attr_put_simple(ri, var, 'strz')
+
+    def _attr_get(self, ri, var):
+        len_mem = var + '->_present.' + self.c_name + '_len'
+        return [f"{len_mem} = len;",
+                f"{var}->{self.c_name} = malloc(len + 1);",
+                f"memcpy({var}->{self.c_name}, mnl_attr_get_str(attr), len);",
+                f"{var}->{self.c_name}[len] = 0;"], \
+               ['len = strnlen(mnl_attr_get_str(attr), mnl_attr_get_payload_len(attr));'], \
+               ['unsigned int len;']
+
+    def _setter_lines(self, ri, member, presence):
+        return [f"free({member});",
+                f"{presence}_len = strlen({self.c_name});",
+                f"{member} = malloc({presence}_len + 1);",
+                f'memcpy({member}, {self.c_name}, {presence}_len);',
+                f'{member}[{presence}_len] = 0;']
+
+
+class TypeBinary(Type):
+    def arg_member(self, ri):
+        return [f"const void *{self.c_name}", 'size_t len']
+
+    def presence_type(self):
+        return 'len'
+
+    def struct_member(self, ri):
+        ri.cw.p(f"void *{self.c_name};")
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_BINARY,'
+
+    def _attr_policy(self, policy):
+        mem = '{ '
+        if len(self.checks) == 1 and 'min-len' in self.checks:
+            mem += '.len = ' + str(self.checks['min-len'])
+        else:
+            raise Exception('Binary type not implemented, yet')
+        mem += ', }'
+        return mem
+
+    def attr_put(self, ri, var):
+        self._attr_put_line(ri, var, f"mnl_attr_put(nlh, {self.enum_name}, " +
+                            f"{var}->_present.{self.c_name}_len, {var}->{self.c_name})")
+
+    def _attr_get(self, ri, var):
+        len_mem = var + '->_present.' + self.c_name + '_len'
+        return [f"{len_mem} = len;",
+                f"{var}->{self.c_name} = malloc(len);",
+                f"memcpy({var}->{self.c_name}, mnl_attr_get_payload(attr), len);"], \
+               ['len = mnl_attr_get_payload_len(attr);'], \
+               ['unsigned int len;']
+
+    def _setter_lines(self, ri, member, presence):
+        return [f"free({member});",
+                f"{member} = malloc({presence}_len);",
+                f'memcpy({member}, {self.c_name}, {presence}_len);']
+
+
+class TypeNest(Type):
+    def _complex_member_type(self, ri):
+        return f"struct {self.nested_render_name}"
+
+    def free(self, ri, var, ref):
+        ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name});')
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
+
+    def attr_put(self, ri, var):
+        self._attr_put_line(ri, var, f"{self.nested_render_name}_put(nlh, " +
+                            f"{self.enum_name}, &{var}->{self.c_name})")
+
+    def _attr_get(self, ri, var):
+        get_lines = [f"{self.nested_render_name}_parse(&parg, attr);"]
+        init_lines = [f"parg.rsp_policy = &{self.nested_render_name}_nest;",
+                      f"parg.data = &{var}->{self.c_name};"]
+        return get_lines, init_lines, None
+
+    def setter(self, ri, space, direction, deref=False, ref=None):
+        ref = (ref if ref else []) + [self.c_name]
+
+        for _, attr in ri.family.pure_nested_structs[self.nested_attrs].member_list():
+            attr.setter(ri, self.nested_attrs, direction, deref=deref, ref=ref)
+
+
+class TypeMultiAttr(Type):
+    def is_multi_val(self):
+        return True
+
+    def presence_type(self):
+        return 'count'
+
+    def _complex_member_type(self, ri):
+        if 'type' not in self.attr or self.attr['type'] == 'nest':
+            return f"struct {self.nested_render_name}"
+        elif self.attr['type'] in scalars:
+            scalar_pfx = '__' if ri.ku_space == 'user' else ''
+            return scalar_pfx + self.attr['type']
+        else:
+            raise Exception(f"Sub-type {self.attr['type']} not supported yet")
+
+    def free_needs_iter(self):
+        return 'type' not in self.attr or self.attr['type'] == 'nest'
+
+    def free(self, ri, var, ref):
+        if 'type' not in self.attr or self.attr['type'] == 'nest':
+            ri.cw.p(f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)")
+            ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);')
+
+    def _attr_typol(self):
+        if 'type' not in self.attr or self.attr['type'] == 'nest':
+            return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
+        elif self.attr['type'] in scalars:
+            return f".type = YNL_PT_U{self.attr['type'][1:]}, "
+        else:
+            raise Exception(f"Sub-type {self.attr['type']} not supported yet")
+
+    def _attr_get(self, ri, var):
+        return f'{var}->n_{self.c_name}++;', None, None
+
+
+class TypeArrayNest(Type):
+    def is_multi_val(self):
+        return True
+
+    def presence_type(self):
+        return 'count'
+
+    def _complex_member_type(self, ri):
+        if 'sub-type' not in self.attr or self.attr['sub-type'] == 'nest':
+            return f"struct {self.nested_render_name}"
+        elif self.attr['sub-type'] in scalars:
+            scalar_pfx = '__' if ri.ku_space == 'user' else ''
+            return scalar_pfx + self.attr['sub-type']
+        else:
+            raise Exception(f"Sub-type {self.attr['sub-type']} not supported yet")
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
+
+    def _attr_get(self, ri, var):
+        local_vars = ['const struct nlattr *attr2;']
+        get_lines = [f'attr_{self.c_name} = attr;',
+                     'mnl_attr_for_each_nested(attr2, attr)',
+                     f'\t{var}->n_{self.c_name}++;']
+        return get_lines, None, local_vars
+
+
+class TypeNestTypeValue(Type):
+    def _complex_member_type(self, ri):
+        return f"struct {self.nested_render_name}"
+
+    def _attr_typol(self):
+        return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
+
+    def _attr_get(self, ri, var):
+        prev = 'attr'
+        tv_args = ''
+        get_lines = []
+        local_vars = []
+        init_lines = [f"parg.rsp_policy = &{self.nested_render_name}_nest;",
+                      f"parg.data = &{var}->{self.c_name};"]
+        if 'type-value' in self.attr:
+            tv_names = [x.replace('-', '_') for x in self.attr["type-value"]]
+            local_vars += [f'const struct nlattr *attr_{", *attr_".join(tv_names)};']
+            local_vars += [f'__u32 {", ".join(tv_names)};']
+            for level in self.attr["type-value"]:
+                level = level.replace('-', '_')
+                get_lines += [f'attr_{level} = mnl_attr_get_payload({prev});']
+                get_lines += [f'{level} = mnl_attr_get_type(attr_{level});']
+                prev = 'attr_' + level
+
+            tv_args = f", {', '.join(tv_names)}"
+
+        get_lines += [f"{self.nested_render_name}_parse(&parg, {prev}{tv_args});"]
+        return get_lines, init_lines, local_vars
+
+
+class Struct:
+    def __init__(self, family, space_name, type_list=None, inherited=None):
+        self.family = family
+        self.space_name = space_name
+        self.attr_set = family.attr_sets[space_name]
+        # Use list to catch comparisons with empty sets
+        self._inherited = inherited if inherited is not None else []
+        self.inherited = []
+
+        self.nested = type_list is None
+        if family.name == space_name.replace('-', '_'):
+            self.render_name = f"{family.name}"
+        else:
+            self.render_name = f"{family.name}_{space_name.replace('-', '_')}"
+        self.struct_name = 'struct ' + self.render_name
+        self.ptr_name = self.struct_name + ' *'
+
+        self.request = False
+        self.reply = False
+
+        self.attr_list = []
+        self.attrs = dict()
+        if type_list:
+            for t in type_list:
+                self.attr_list.append((t, self.attr_set[t]),)
+        else:
+            for t in self.attr_set:
+                self.attr_list.append((t, self.attr_set[t]),)
+
+        max_val = 0
+        self.attr_max_val = None
+        for name, attr in self.attr_list:
+            if attr.value > max_val:
+                max_val = attr.value
+                self.attr_max_val = attr
+            self.attrs[name] = attr
+
+    def __iter__(self):
+        yield from self.attrs
+
+    def __getitem__(self, key):
+        return self.attrs[key]
+
+    def member_list(self):
+        return self.attr_list
+
+    def set_inherited(self, new_inherited):
+        if self._inherited != new_inherited:
+            raise Exception("Inheriting different members not supported")
+        self.inherited = [x.replace('-', '_') for x in sorted(self._inherited)]
+
+
+class AttrSet:
+    def __init__(self, family, yaml):
+        self.yaml = yaml
+
+        self.attrs = dict()
+        self.name = self.yaml['name']
+        if 'subset-of' not in yaml:
+            self.subset_of = None
+            if 'name-prefix' in yaml:
+                pfx = yaml['name-prefix']
+            elif self.name == family.name:
+                pfx = family.name + '-a-'
+            else:
+                pfx = f"{family.name}-a-{self.name}-"
+            self.name_prefix = c_upper(pfx)
+            self.max_name = c_upper(self.yaml.get('attr-max-name', f"{self.name_prefix}max"))
+        else:
+            self.subset_of = self.yaml['subset-of']
+            self.name_prefix = family.attr_sets[self.subset_of].name_prefix
+            self.max_name = family.attr_sets[self.subset_of].max_name
+
+        self.c_name = self.name.replace('-', '_')
+        if self.c_name in c_kw:
+            self.c_name += '_'
+        if self.c_name == family.c_name:
+            self.c_name = ''
+
+        val = 0
+        for elem in self.yaml['attributes']:
+            if 'value' in elem:
+                val = elem['value']
+            else:
+                elem['value'] = val
+            val += 1
+
+            if 'multi-attr' in elem and elem['multi-attr']:
+                attr = TypeMultiAttr(family, self, elem)
+            elif elem['type'] in scalars:
+                attr = TypeScalar(family, self, elem)
+            elif elem['type'] == 'unused':
+                attr = TypeUnused(family, self, elem)
+            elif elem['type'] == 'flag':
+                attr = TypeFlag(family, self, elem)
+            elif elem['type'] == 'string':
+                attr = TypeString(family, self, elem)
+            elif elem['type'] == 'binary':
+                attr = TypeBinary(family, self, elem)
+            elif elem['type'] == 'nest':
+                attr = TypeNest(family, self, elem)
+            elif elem['type'] == 'array-nest':
+                attr = TypeArrayNest(family, self, elem)
+            elif elem['type'] == 'nest-type-value':
+                attr = TypeNestTypeValue(family, self, elem)
+            else:
+                raise Exception(f"No typed class for type {elem['type']}")
+
+            self.attrs[elem['name']] = attr
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
+class Operation:
+    def __init__(self, family, yaml, value):
+        self.yaml = yaml
+        self.value = value
+
+        self.name = self.yaml['name']
+        self.render_name = family.name + '_' + self.name.replace('-', '_')
+        self.is_async = 'notify' in yaml or 'event' in yaml
+        if not self.is_async:
+            self.enum_name = family.op_prefix + self.name.upper().replace('-', '_')
+        else:
+            self.enum_name = family.async_op_prefix + self.name.upper().replace('-', '_')
+
+    def __getitem__(self, key):
+        return self.yaml[key]
+
+    def __contains__(self, key):
+        return key in self.yaml
+
+    def add_notification(self, op):
+        if 'notify' not in self.yaml:
+            self.yaml['notify'] = dict()
+            self.yaml['notify']['reply'] = self.yaml['do']['reply']
+            self.yaml['notify']['cmds'] = []
+        self.yaml['notify']['cmds'].append(op)
+
+
+class Family:
+    def __init__(self, file_name):
+        with open(file_name, "r") as stream:
+            self.yaml = yaml.safe_load(stream)
+
+        proto = self.yaml.get('protocol', 'genetlink')
+
+        with open(os.path.dirname(os.path.dirname(file_name)) + f'/{proto}.yaml', "r") as stream:
+            schema = yaml.safe_load(stream)
+
+        jsonschema.validate(self.yaml, schema)
+
+        if self.yaml.get('protocol', 'genetlink') not in {'genetlink', 'genetlink-c', 'genetlink-legacy'}:
+            raise Exception("Codegen only supported for genetlink")
+
+        if 'definitions' not in self.yaml:
+            self.yaml['definitions'] = []
+
+        self.name = self.yaml['name']
+        self.c_name = self.name.replace('-', '_')
+        if 'uapi-header' in self.yaml:
+            self.uapi_header = self.yaml['uapi-header']
+        else:
+            self.uapi_header = f"linux/{self.name}.h"
+        if 'name-prefix' in self.yaml['operations']:
+            self.op_prefix = self.yaml['operations']['name-prefix'].upper().replace('-', '_')
+        else:
+            self.op_prefix = (self.yaml['name'] + '-cmd-').upper().replace('-', '_')
+        if 'async-prefix' in self.yaml['operations']:
+            self.async_op_prefix = self.yaml['operations']['async-prefix'].upper().replace('-', '_')
+        else:
+            self.async_op_prefix = self.op_prefix
+
+        self.consts = dict()
+        self.ops = dict()
+        self.ops_list = []
+        self.attr_sets = dict()
+        self.attr_sets_list = []
+
+        # dict space-name -> 'request': set(attrs), 'reply': set(attrs)
+        self.root_sets = dict()
+        # dict space-name -> set('request', 'reply')
+        self.pure_nested_structs = dict()
+        self.all_notify = dict()
+
+        self._mock_up_events()
+
+        self._dictify()
+        self._load_root_sets()
+        self._load_nested_sets()
+        self._load_all_notify()
+
+        self.kernel_policy = self.yaml.get('kernel-policy', 'per-op')
+        if self.kernel_policy == 'global':
+            self._load_global_policy()
+
+    def __getitem__(self, key):
+        return self.yaml[key]
+
+    def get(self, key, default=None):
+        return self.yaml.get(key, default)
+
+    # Fake a 'do' equivalent of all events, so that we can render their response parsing
+    def _mock_up_events(self):
+        for op in self.yaml['operations']['list']:
+            if 'event' in op:
+                op['do'] = {
+                    'reply': {
+                        'attributes': op['event']['attributes']
+                    }
+                }
+
+    def _dictify(self):
+        for elem in self.yaml['definitions']:
+            self.consts[elem['name']] = elem
+
+        for elem in self.yaml['attribute-sets']:
+            attr_set = AttrSet(self, elem)
+            self.attr_sets[elem['name']] = attr_set
+            self.attr_sets_list.append((elem['name'], attr_set), )
+
+        ntf = []
+        val = 0
+        for elem in self.yaml['operations']['list']:
+            if 'value' in elem:
+                val = elem['value']
+
+            op = Operation(self, elem, val)
+            val += 1
+
+            self.ops_list.append((elem['name'], op),)
+            if 'notify' in elem:
+                ntf.append(op)
+                continue
+            if 'attribute-set' not in elem:
+                continue
+            self.ops[elem['name']] = op
+        for n in ntf:
+            self.ops[n['notify']].add_notification(n)
+
+    def _load_root_sets(self):
+        for op_name, op in self.ops.items():
+            if 'attribute-set' not in op:
+                continue
+
+            req_attrs = set()
+            rsp_attrs = set()
+            for op_mode in ['do', 'dump']:
+                if op_mode in op and 'request' in op[op_mode]:
+                    req_attrs.update(set(op[op_mode]['request']['attributes']))
+                if op_mode in op and 'reply' in op[op_mode]:
+                    rsp_attrs.update(set(op[op_mode]['reply']['attributes']))
+
+            if op['attribute-set'] not in self.root_sets:
+                self.root_sets[op['attribute-set']] = {'request': req_attrs, 'reply': rsp_attrs}
+            else:
+                self.root_sets[op['attribute-set']]['request'].update(req_attrs)
+                self.root_sets[op['attribute-set']]['reply'].update(rsp_attrs)
+
+    def _load_nested_sets(self):
+        for root_set, rs_members in self.root_sets.items():
+            for attr, spec in self.attr_sets[root_set].items():
+                if 'nested-attributes' in spec:
+                    inherit = set()
+                    nested = spec['nested-attributes']
+                    if nested not in self.root_sets:
+                        self.pure_nested_structs[nested] = Struct(self, nested, inherited=inherit)
+                    if attr in rs_members['request']:
+                        self.pure_nested_structs[nested].request = True
+                    if attr in rs_members['reply']:
+                        self.pure_nested_structs[nested].reply = True
+
+                    if 'type-value' in spec:
+                        if nested in self.root_sets:
+                            raise Exception("Inheriting members to a space used as root not supported")
+                        inherit.update(set(spec['type-value']))
+                    elif spec['type'] == 'array-nest':
+                        inherit.add('idx')
+                    self.pure_nested_structs[nested].set_inherited(inherit)
+
+    def _load_all_notify(self):
+        for op_name, op in self.ops.items():
+            if not op:
+                continue
+
+            if 'notify' in op:
+                self.all_notify[op_name] = op['notify']['cmds']
+
+    def _load_global_policy(self):
+        global_set = set()
+        attr_set_name = None
+        for op_name, op in self.ops.items():
+            if not op:
+                continue
+            if 'attribute-set' not in op:
+                continue
+
+            if attr_set_name is None:
+                attr_set_name = op['attribute-set']
+            if attr_set_name != op['attribute-set']:
+                raise Exception('For a global policy all ops must use the same set')
+
+            for op_mode in {'do', 'dump'}:
+                if op_mode in op:
+                    global_set.update(op[op_mode].get('request', []))
+
+        self.global_policy = []
+        self.global_policy_set = attr_set_name
+        for attr in self.attr_sets[attr_set_name]:
+            if attr in global_set:
+                self.global_policy.append(attr)
+
+
+class RenderInfo:
+    def __init__(self, cw, family, ku_space, op, op_name, op_mode, attr_set=None):
+        self.family = family
+        self.nl = cw.nlib
+        self.ku_space = ku_space
+        self.op = op
+        self.op_name = op_name
+        self.op_mode = op_mode
+
+        # 'do' and 'dump' response parsing is identical
+        if op_mode != 'do' and 'dump' in op and 'do' in op and 'reply' in op['do'] and \
+           op["do"]["reply"] == op["dump"]["reply"]:
+            self.type_consistent = True
+        else:
+            self.type_consistent = op_mode == 'event'
+
+        self.attr_set = attr_set
+        if not self.attr_set:
+            self.attr_set = op['attribute-set']
+
+        if op:
+            self.type_name = op_name.replace('-', '_')
+        else:
+            self.type_name = attr_set.replace('-', '_')
+
+        self.cw = cw
+
+        self.struct = dict()
+        for op_dir in ['request', 'reply']:
+            if op and op_dir in op[op_mode]:
+                self.struct[op_dir] = Struct(family, self.attr_set,
+                                             type_list=op[op_mode][op_dir]['attributes'])
+        if op_mode == 'event':
+            self.struct['reply'] = Struct(family, self.attr_set, type_list=op['event']['attributes'])
+
+
+class CodeWriter:
+    def __init__(self, nlib):
+        self.nlib = nlib
+
+        self._nl = False
+        self._silent_block = False
+        self._ind = 0
+
+    @classmethod
+    def _is_cond(cls, line):
+        return line.startswith('if') or line.startswith('while') or line.startswith('for')
+
+    def p(self, line, add_ind=0):
+        if self._nl:
+            print()
+            self._nl = False
+        ind = self._ind
+        if line[-1] == ':':
+            ind -= 1
+        if self._silent_block:
+            ind += 1
+        self._silent_block = line.endswith(')') and CodeWriter._is_cond(line)
+        if add_ind:
+            ind += add_ind
+        print('\t' * ind + line)
+
+    def nl(self):
+        self._nl = True
+
+    def block_start(self, line=''):
+        if line:
+            line = line + ' '
+        self.p(line + '{')
+        self._ind += 1
+
+    def block_end(self, line=''):
+        if line and line[0] not in {';', ','}:
+            line = ' ' + line
+        self._ind -= 1
+        self.p('}' + line)
+
+    def write_func_prot(self, qual_ret, name, args=None, doc=None, suffix=''):
+        if not args:
+            args = ['void']
+
+        if doc:
+            self.p('/*')
+            self.p(' * ' + doc)
+            self.p(' */')
+
+        oneline = qual_ret
+        if qual_ret[-1] != '*':
+            oneline += ' '
+        oneline += f"{name}({', '.join(args)}){suffix}"
+
+        if len(oneline) < 80:
+            self.p(oneline)
+            return
+
+        v = qual_ret
+        if len(v) > 3:
+            self.p(v)
+            v = ''
+        elif qual_ret[-1] != '*':
+            v += ' '
+        v += name + '('
+        ind = '\t' * (len(v) // 8) + ' ' * (len(v) % 8)
+        delta_ind = len(v) - len(ind)
+        v += args[0]
+        i = 1
+        while i < len(args):
+            next_len = len(v) + len(args[i])
+            if v[0] == '\t':
+                next_len += delta_ind
+            if next_len > 76:
+                self.p(v + ',')
+                v = ind
+            else:
+                v += ', '
+            v += args[i]
+            i += 1
+        self.p(v + ')' + suffix)
+
+    def write_func_lvar(self, local_vars):
+        if not local_vars:
+            return
+
+        if type(local_vars) is str:
+            local_vars = [local_vars]
+
+        local_vars.sort(key=len, reverse=True)
+        for var in local_vars:
+            self.p(var)
+        self.nl()
+
+    def write_func(self, qual_ret, name, body, args=None, local_vars=None):
+        self.write_func_prot(qual_ret=qual_ret, name=name, args=args)
+        self.write_func_lvar(local_vars=local_vars)
+
+        self.block_start()
+        for line in body:
+            self.p(line)
+        self.block_end()
+
+    def writes_defines(self, defines):
+        longest = 0
+        for define in defines:
+            if len(define[0]) > longest:
+                longest = len(define[0])
+        longest = ((longest + 8) // 8) * 8
+        for define in defines:
+            line = '#define ' + define[0]
+            line += '\t' * ((longest - len(define[0]) + 7) // 8)
+            if type(define[1]) is int:
+                line += str(define[1])
+            elif type(define[1]) is str:
+                line += '"' + define[1] + '"'
+            self.p(line)
+
+
+scalars = {'u8', 'u16', 'u32', 'u64', 's32', 's64'}
+
+direction_to_suffix = {
+    'reply': '_rsp',
+    'request': '_req',
+    '': ''
+}
+
+op_mode_to_wrapper = {
+    'do': '',
+    'dump': '_list',
+    'notify': '_ntf',
+    'event': '',
+}
+
+c_kw = {
+    'do'
+}
+
+
+def rdir(direction):
+    if direction == 'reply':
+        return 'request'
+    if direction == 'request':
+        return 'reply'
+    return direction
+
+
+def op_prefix(ri, direction, deref=False):
+    suffix = f"_{ri.type_name}"
+
+    if not ri.op_mode or ri.op_mode == 'do':
+        suffix += f"{direction_to_suffix[direction]}"
+    else:
+        if direction == 'request':
+            suffix += '_req_dump'
+        else:
+            if ri.type_consistent:
+                if deref:
+                    suffix += f"{direction_to_suffix[direction]}"
+                else:
+                    suffix += op_mode_to_wrapper[ri.op_mode]
+            else:
+                suffix += '_rsp'
+                suffix += '_dump' if deref else '_list'
+
+    return f"{ri.family['name']}{suffix}"
+
+
+def type_name(ri, direction, deref=False):
+    return f"struct {op_prefix(ri, direction, deref=deref)}"
+
+
+def print_prototype(ri, direction, terminate=True, doc=None):
+    suffix = ';' if terminate else ''
+
+    fname = ri.op.render_name
+    if ri.op_mode == 'dump':
+        fname += '_dump'
+
+    args = ['struct ynl_sock *ys']
+    if 'request' in ri.op[ri.op_mode]:
+        args.append(f"{type_name(ri, direction)} *" + f"{direction_to_suffix[direction][1:]}")
+
+    ret = 'int'
+    if 'reply' in ri.op[ri.op_mode]:
+        ret = f"{type_name(ri, rdir(direction))} *"
+
+    ri.cw.write_func_prot(ret, fname, args, doc=doc, suffix=suffix)
+
+
+def print_req_prototype(ri):
+    print_prototype(ri, "request", doc=ri.op['doc'])
+
+
+def print_dump_prototype(ri):
+    print_prototype(ri, "request")
+
+
+def put_typol_fwd(cw, struct):
+    cw.p(f'extern struct ynl_policy_nest {struct.render_name}_nest;')
+
+
+def put_typol(cw, struct):
+    type_max = struct.attr_set.max_name
+    cw.block_start(line=f'struct ynl_policy_attr {struct.render_name}_policy[{type_max} + 1] =')
+
+    for _, arg in struct.member_list():
+        arg.attr_typol(cw)
+
+    cw.block_end(line=';')
+    cw.nl()
+
+    cw.block_start(line=f'struct ynl_policy_nest {struct.render_name}_nest =')
+    cw.p(f'.max_attr = {type_max},')
+    cw.p(f'.table = {struct.render_name}_policy,')
+    cw.block_end(line=';')
+    cw.nl()
+
+
+def put_req_nested(ri, struct):
+    func_args = ['struct nlmsghdr *nlh',
+                 'unsigned int attr_type',
+                 f'{struct.ptr_name}obj']
+
+    ri.cw.write_func_prot('int', f'{struct.render_name}_put', func_args)
+    ri.cw.block_start()
+    ri.cw.write_func_lvar('struct nlattr *nest;')
+
+    ri.cw.p("nest = mnl_attr_nest_start(nlh, attr_type);")
+
+    for _, arg in struct.member_list():
+        arg.attr_put(ri, "obj")
+
+    ri.cw.p("mnl_attr_nest_end(nlh, nest);")
+
+    ri.cw.nl()
+    ri.cw.p('return 0;')
+    ri.cw.block_end()
+    ri.cw.nl()
+
+
+def _multi_parse(ri, struct, init_lines, local_vars):
+    if struct.nested:
+        iter_line = "mnl_attr_for_each_nested(attr, nested)"
+    else:
+        iter_line = "mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr))"
+
+    array_nests = set()
+    multi_attrs = set()
+    needs_parg = False
+    for arg, aspec in struct.member_list():
+        if aspec['type'] == 'array-nest':
+            local_vars.append(f'const struct nlattr *attr_{aspec.c_name};')
+            array_nests.add(arg)
+        if 'multi-attr' in aspec:
+            multi_attrs.add(arg)
+        needs_parg |= 'nested-attributes' in aspec
+    if array_nests or multi_attrs:
+        local_vars.append('int i;')
+    if needs_parg:
+        local_vars.append('struct ynl_parse_arg parg;')
+        init_lines.append('parg.ys = yarg->ys;')
+
+    ri.cw.block_start()
+    ri.cw.write_func_lvar(local_vars)
+
+    for line in init_lines:
+        ri.cw.p(line)
+    ri.cw.nl()
+
+    for arg in struct.inherited:
+        ri.cw.p(f'dst->{arg} = {arg};')
+
+    ri.cw.nl()
+    ri.cw.block_start(line=iter_line)
+
+    first = True
+    for _, arg in struct.member_list():
+        arg.attr_get(ri, 'dst', first=first)
+        first = False
+
+    ri.cw.block_end()
+    ri.cw.nl()
+
+    for anest in sorted(array_nests):
+        aspec = struct[anest]
+
+        ri.cw.block_start(line=f"if (dst->n_{aspec.c_name})")
+        ri.cw.p(f"dst->{aspec.c_name} = calloc(dst->n_{aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.p('i = 0;')
+        ri.cw.p(f"parg.rsp_policy = &{aspec.nested_render_name}_nest;")
+        ri.cw.block_start(line=f"mnl_attr_for_each_nested(attr, attr_{aspec.c_name})")
+        ri.cw.p(f"parg.data = &dst->{aspec.c_name}[i];")
+        ri.cw.p(f"if ({aspec.nested_render_name}_parse(&parg, attr, mnl_attr_get_type(attr)))")
+        ri.cw.p('return MNL_CB_ERROR;')
+        ri.cw.p('i++;')
+        ri.cw.block_end()
+        ri.cw.block_end()
+    ri.cw.nl()
+
+    for anest in sorted(multi_attrs):
+        aspec = struct[anest]
+        ri.cw.block_start(line=f"if (dst->n_{aspec.c_name})")
+        ri.cw.p(f"dst->{aspec.c_name} = calloc(dst->n_{aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.p('i = 0;')
+        if 'nested-attributes' in aspec:
+            ri.cw.p(f"parg.rsp_policy = &{aspec.nested_render_name}_nest;")
+        ri.cw.block_start(line=iter_line)
+        ri.cw.block_start(line=f"if (mnl_attr_get_type(attr) == {aspec.enum_name})")
+        if 'nested-attributes' in aspec:
+            ri.cw.p(f"parg.data = &dst->{aspec.c_name}[i];")
+            ri.cw.p(f"if ({aspec.nested_render_name}_parse(&parg, attr))")
+            ri.cw.p('return MNL_CB_ERROR;')
+        elif aspec['type'] in scalars:
+            t = aspec['type']
+            if t[0] == 's':
+                t = 'u' + t[1:]
+            ri.cw.p(f"dst->{aspec.c_name}[i] = mnl_attr_get_{t}(attr);")
+        else:
+            raise Exception('Nest parsing type not supported yet')
+        ri.cw.p('i++;')
+        ri.cw.block_end()
+        ri.cw.block_end()
+        ri.cw.block_end()
+    ri.cw.nl()
+
+    if struct.nested:
+        ri.cw.p('return 0;')
+    else:
+        ri.cw.p('return MNL_CB_OK;')
+    ri.cw.block_end()
+    ri.cw.nl()
+
+
+def parse_rsp_nested(ri, struct):
+    func_args = ['struct ynl_parse_arg *yarg',
+                 'const struct nlattr *nested']
+    for arg in struct.inherited:
+        func_args.append('__u32 ' + arg)
+
+    local_vars = ['const struct nlattr *attr;',
+                  f'{struct.ptr_name}dst = yarg->data;']
+    init_lines = []
+
+    ri.cw.write_func_prot('int', f'{struct.render_name}_parse', func_args)
+
+    _multi_parse(ri, struct, init_lines, local_vars)
+
+
+def parse_rsp_msg(ri, deref=False):
+    if 'reply' not in ri.op[ri.op_mode] and ri.op_mode != 'event':
+        return
+
+    func_args = ['const struct nlmsghdr *nlh',
+                 'void *data']
+
+    local_vars = [f'{type_name(ri, "reply", deref=deref)} *dst;',
+                  'struct ynl_parse_arg *yarg = data;',
+                  'const struct nlattr *attr;']
+    init_lines = ['dst = yarg->data;']
+
+    ri.cw.write_func_prot('int', f'{op_prefix(ri, "reply", deref=deref)}_parse', func_args)
+
+    _multi_parse(ri, ri.struct["reply"], init_lines, local_vars)
+
+
+def print_req(ri):
+    ret_ok = '0'
+    ret_err = '-1'
+    direction = "request"
+    local_vars = ['struct nlmsghdr *nlh;',
+                  'int len, err;']
+
+    if 'reply' in ri.op[ri.op_mode]:
+        ret_ok = 'rsp'
+        ret_err = 'NULL'
+        local_vars += [f'{type_name(ri, rdir(direction))} *rsp;',
+                       'struct ynl_parse_arg yarg = { .ys = ys, };']
+
+    print_prototype(ri, direction, terminate=False)
+    ri.cw.block_start()
+    ri.cw.write_func_lvar(local_vars)
+
+    ri.cw.p(f"nlh = ynl_gemsg_start_req(ys, {ri.nl.get_family_id()}, {ri.op.enum_name}, 1);")
+
+    ri.cw.p(f"ys->req_policy = &{ri.struct['request'].render_name}_nest;")
+    if 'reply' in ri.op[ri.op_mode]:
+        ri.cw.p(f"yarg.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
+    ri.cw.nl()
+    for _, attr in ri.struct["request"].member_list():
+        attr.attr_put(ri, "req")
+    ri.cw.nl()
+
+    ri.cw.p('err = mnl_socket_sendto(ys->sock, nlh, nlh->nlmsg_len);')
+    ri.cw.p('if (err < 0)')
+    ri.cw.p(f"return {ret_err};")
+    ri.cw.nl()
+    ri.cw.p('len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);')
+    ri.cw.p('if (len < 0)')
+    ri.cw.p(f"return {ret_err};")
+    ri.cw.nl()
+
+    if 'reply' in ri.op[ri.op_mode]:
+        ri.cw.p('rsp = calloc(1, sizeof(*rsp));')
+        ri.cw.p('yarg.data = rsp;')
+        ri.cw.nl()
+        ri.cw.p(f"err = {ri.nl.parse_cb_run(op_prefix(ri, 'reply') + '_parse', '&yarg', False)};")
+        ri.cw.p('if (err < 0)')
+        ri.cw.p('goto err_free;')
+        ri.cw.nl()
+
+    ri.cw.p('err = ynl_recv_ack(ys, err);')
+    ri.cw.p('if (err)')
+    ri.cw.p('goto err_free;')
+    ri.cw.nl()
+    ri.cw.p(f"return {ret_ok};")
+    ri.cw.nl()
+    ri.cw.p('err_free:')
+
+    if 'reply' in ri.op[ri.op_mode]:
+        ri.cw.p(f"{call_free(ri, rdir(direction), 'rsp')}")
+    ri.cw.p(f"return {ret_err};")
+    ri.cw.block_end()
+
+
+def print_dump(ri):
+    direction = "request"
+    print_prototype(ri, direction, terminate=False)
+    ri.cw.block_start()
+    local_vars = ['struct ynl_dump_state yds = {};',
+                  'struct nlmsghdr *nlh;',
+                  'int len, err;']
+
+    for var in local_vars:
+        ri.cw.p(f'{var}')
+    ri.cw.nl()
+
+    ri.cw.p('yds.ys = ys;')
+    ri.cw.p(f"yds.alloc_sz = sizeof({type_name(ri, rdir(direction))});")
+    ri.cw.p(f"yds.cb = {op_prefix(ri, 'reply', deref=True)}_parse;")
+    ri.cw.p(f"yds.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
+    ri.cw.nl()
+    ri.cw.p(f"nlh = ynl_gemsg_start_dump(ys, {ri.nl.get_family_id()}, {ri.op.enum_name}, 1);")
+
+    if "request" in ri.op[ri.op_mode]:
+        ri.cw.p(f"ys->req_policy = &{ri.struct['request'].render_name}_nest;")
+        ri.cw.nl()
+        for _, attr in ri.struct["request"].member_list():
+            attr.attr_put(ri, "req")
+    ri.cw.nl()
+
+    ri.cw.p('err = mnl_socket_sendto(ys->sock, nlh, nlh->nlmsg_len);')
+    ri.cw.p('if (err < 0)')
+    ri.cw.p('return NULL;')
+    ri.cw.nl()
+
+    ri.cw.block_start(line='do')
+    ri.cw.p('len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);')
+    ri.cw.p('if (len < 0)')
+    ri.cw.p('goto free_list;')
+    ri.cw.nl()
+    ri.cw.p(f"err = {ri.nl.parse_cb_run('ynl_dump_trampoline', '&yds', False, indent=2)};")
+    ri.cw.p('if (err < 0)')
+    ri.cw.p('goto free_list;')
+    ri.cw.block_end(line='while (err > 0);')
+    ri.cw.nl()
+
+    ri.cw.p('return yds.first;')
+    ri.cw.nl()
+    ri.cw.p('free_list:')
+    ri.cw.p(call_free(ri, rdir(direction), 'yds.first'))
+    ri.cw.p('return NULL;')
+    ri.cw.block_end()
+
+
+def call_free(ri, direction, var):
+    return f"{op_prefix(ri, direction)}_free({var});"
+
+
+def free_arg_name(direction):
+    if direction:
+        return direction_to_suffix[direction][1:]
+    return 'obj'
+
+
+def print_free_prototype(ri, direction, suffix=';'):
+    name = op_prefix(ri, direction)
+    arg = free_arg_name(direction)
+    ri.cw.write_func_prot('void', f"{name}_free", [f"struct {name} *{arg}"], suffix=suffix)
+
+
+def _print_type(ri, direction, struct):
+    suffix = f'_{ri.type_name}{direction_to_suffix[direction]}'
+
+    if ri.op_mode == 'dump':
+        suffix += '_dump'
+
+    ri.cw.block_start(line=f"struct {ri.family['name']}{suffix}")
+
+    meta_started = False
+    for _, attr in struct.member_list():
+        for type_filter in ['len', 'bit']:
+            line = attr.presence_member(ri.ku_space, type_filter)
+            if line:
+                if not meta_started:
+                    ri.cw.block_start(line=f"struct")
+                    meta_started = True
+                ri.cw.p(line)
+    if meta_started:
+        ri.cw.block_end(line='_present;')
+        ri.cw.nl()
+
+    for arg in struct.inherited:
+        ri.cw.p(f"__u32 {arg};")
+
+    for _, attr in struct.member_list():
+        attr.struct_member(ri)
+
+    ri.cw.block_end(line=';')
+    ri.cw.nl()
+
+
+def print_type(ri, direction):
+    _print_type(ri, direction, ri.struct[direction])
+
+
+def print_type_full(ri, struct):
+    _print_type(ri, "", struct)
+
+
+def print_type_helpers(ri, direction, deref=False):
+    print_free_prototype(ri, direction)
+
+    if ri.ku_space == 'user' and direction == 'request':
+        for _, attr in ri.struct[direction].member_list():
+            attr.setter(ri, ri.attr_set, direction, deref=deref)
+    ri.cw.nl()
+
+
+def print_req_type_helpers(ri):
+    print_type_helpers(ri, "request")
+
+
+def print_rsp_type_helpers(ri):
+    if 'reply' not in ri.op[ri.op_mode]:
+        return
+    print_type_helpers(ri, "reply")
+
+
+def print_parse_prototype(ri, direction, terminate=True):
+    suffix = "_rsp" if direction == "reply" else "_req"
+    term = ';' if terminate else ''
+
+    ri.cw.write_func_prot('void', f"{ri.op.render_name}{suffix}_parse",
+                          ['const struct nlattr **tb',
+                           f"struct {ri.op.render_name}{suffix} *req"],
+                          suffix=term)
+
+
+def print_req_type(ri):
+    print_type(ri, "request")
+
+
+def print_rsp_type(ri):
+    if (ri.op_mode == 'do' or ri.op_mode == 'dump') and 'reply' in ri.op[ri.op_mode]:
+        direction = 'reply'
+    elif ri.op_mode == 'event':
+        direction = 'reply'
+    else:
+        return
+    print_type(ri, direction)
+
+
+def print_wrapped_type(ri):
+    ri.cw.block_start(line=f"{type_name(ri, 'reply')}")
+    if ri.op_mode == 'dump':
+        ri.cw.p(f"{type_name(ri, 'reply')} *next;")
+    elif ri.op_mode == 'notify' or ri.op_mode == 'event':
+        ri.cw.p('__u16 family;')
+        ri.cw.p('__u8 cmd;')
+        ri.cw.p(f"void (*free)({type_name(ri, 'reply')} *ntf);")
+    ri.cw.p(f"{type_name(ri, 'reply', deref=True)} obj __attribute__ ((aligned (8)));")
+    ri.cw.block_end(line=';')
+    ri.cw.nl()
+    print_free_prototype(ri, 'reply')
+    ri.cw.nl()
+
+
+def _free_type_members_iter(ri, struct):
+    for _, attr in struct.member_list():
+        if attr.free_needs_iter():
+            ri.cw.p('unsigned int i;')
+            ri.cw.nl()
+            break
+
+
+def _free_type_members(ri, var, struct, ref=''):
+    for _, attr in struct.member_list():
+        attr.free(ri, var, ref)
+
+
+def _free_type(ri, direction, struct):
+    var = free_arg_name(direction)
+
+    print_free_prototype(ri, direction, suffix='')
+    ri.cw.block_start()
+    _free_type_members_iter(ri, struct)
+    _free_type_members(ri, var, struct)
+    if direction:
+        ri.cw.p(f'free({var});')
+    ri.cw.block_end()
+    ri.cw.nl()
+
+
+def free_rsp_nested(ri, struct):
+    _free_type(ri, "", struct)
+
+
+def print_rsp_free(ri):
+    if 'reply' not in ri.op[ri.op_mode]:
+        return
+    _free_type(ri, 'reply', ri.struct['reply'])
+
+
+def print_dump_type_free(ri):
+    sub_type = type_name(ri, 'reply')
+
+    print_free_prototype(ri, 'reply', suffix='')
+    ri.cw.block_start()
+    ri.cw.p(f"{sub_type} *next = rsp;")
+    ri.cw.nl()
+    ri.cw.block_start(line='while (next)')
+    _free_type_members_iter(ri, ri.struct['reply'])
+    ri.cw.p('rsp = next;')
+    ri.cw.p('next = rsp->next;')
+    ri.cw.nl()
+
+    _free_type_members(ri, 'rsp', ri.struct['reply'], ref='obj.')
+    ri.cw.p(f'free(rsp);')
+    ri.cw.block_end()
+    ri.cw.block_end()
+    ri.cw.nl()
+
+
+def print_ntf_type_free(ri):
+    print_free_prototype(ri, 'reply', suffix='')
+    ri.cw.block_start()
+    _free_type_members_iter(ri, ri.struct['reply'])
+    _free_type_members(ri, 'rsp', ri.struct['reply'], ref='obj.')
+    ri.cw.p(f'free(rsp);')
+    ri.cw.block_end()
+    ri.cw.nl()
+
+
+def print_ntf_parse_prototype(family, cw, suffix=';'):
+    cw.write_func_prot('struct ynl_ntf_base_type *', f"{family['name']}_ntf_parse",
+                       ['struct ynl_sock *ys'], suffix=suffix)
+
+
+def print_ntf_type_parse(family, cw, ku_mode):
+    print_ntf_parse_prototype(family, cw, suffix='')
+    cw.block_start()
+    cw.write_func_lvar(['struct genlmsghdr *genlh;',
+                        'struct nlmsghdr *nlh;',
+                        'struct ynl_parse_arg yarg = { .ys = ys, };',
+                        'struct ynl_ntf_base_type *rsp;',
+                        'int len, err;',
+                        'mnl_cb_t parse;'])
+    cw.p('len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);')
+    cw.p('if (len < (ssize_t)(sizeof(*nlh) + sizeof(*genlh)))')
+    cw.p('return NULL;')
+    cw.nl()
+    cw.p('nlh = (struct nlmsghdr *)ys->rx_buf;')
+    cw.p('genlh = mnl_nlmsg_get_payload(nlh);')
+    cw.nl()
+    cw.block_start(line='switch (genlh->cmd)')
+    for ntf_op in sorted(family.all_notify.keys()):
+        op = family.ops[ntf_op]
+        ri = RenderInfo(cw, family, ku_mode, op, ntf_op, "notify")
+        for ntf in op['notify']['cmds']:
+            cw.p(f"case {ntf.enum_name}:")
+        cw.p(f"rsp = calloc(1, sizeof({type_name(ri, 'notify')}));")
+        cw.p(f"parse = {op_prefix(ri, 'reply', deref=True)}_parse;")
+        cw.p(f"yarg.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
+        cw.p(f"rsp->free = (void *){op_prefix(ri, 'notify')}_free;")
+        cw.p('break;')
+    for op_name, op in family.ops.items():
+        if 'event' not in op:
+            continue
+        ri = RenderInfo(cw, family, ku_mode, op, op_name, "event")
+        cw.p(f"case {op.enum_name}:")
+        cw.p(f"rsp = calloc(1, sizeof({type_name(ri, 'event')}));")
+        cw.p(f"parse = {op_prefix(ri, 'reply', deref=True)}_parse;")
+        cw.p(f"yarg.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
+        cw.p(f"rsp->free = (void *){op_prefix(ri, 'notify')}_free;")
+        cw.p('break;')
+    cw.p('default:')
+    cw.p('ynl_error_unknown_notification(ys, genlh->cmd);')
+    cw.p('return NULL;')
+    cw.block_end()
+    cw.nl()
+    cw.p('yarg.data = rsp->data;')
+    cw.nl()
+    cw.p(f"err = {cw.nlib.parse_cb_run('parse', '&yarg', True)};")
+    cw.p('if (err < 0)')
+    cw.p('goto err_free;')
+    cw.nl()
+    cw.p('rsp->family = nlh->nlmsg_type;')
+    cw.p('rsp->cmd = genlh->cmd;')
+    cw.p('return rsp;')
+    cw.nl()
+    cw.p('err_free:')
+    cw.p('free(rsp);')
+    cw.p('return NULL;')
+    cw.block_end()
+    cw.nl()
+
+
+def print_req_policy_fwd(cw, struct, op=None, terminate=True):
+    prefix = 'extern ' if terminate else ''
+    suffix = ';' if terminate else ' = {'
+    max_attr = struct.attr_max_val
+    name = op.render_name if op else struct.render_name
+    cw.p(f"{prefix}const struct nla_policy {name}_policy[{max_attr.enum_name} + 1]{suffix}")
+
+
+def print_req_policy(cw, struct, op=None):
+    print_req_policy_fwd(cw, struct, op=op, terminate=False)
+    for _, arg in struct.member_list():
+        arg.attr_policy(cw)
+    cw.p("};")
+
+
+def print_kernel_op_table_fwd(family, cw, terminate=True):
+    cw.p(f"// Ops table for {family.name}")
+
+    struct_type = 'genl_small_ops' if family.kernel_policy == 'global' else 'genl_ops'
+    cnt = len(family.ops)
+
+    line = f"const struct {struct_type} {family.name}_ops[{cnt}]"
+    if terminate:
+        cw.p(f"extern {line};")
+    else:
+        cw.block_start(line=line + ' =')
+
+    if not terminate:
+        return
+
+    cw.nl()
+    for op_name, op in family.ops.items():
+        if op.is_async:
+            continue
+
+        if 'do' in op:
+            name = c_lower(f"{family.name}-{op_name}-doit")
+            cw.write_func_prot('int', name,
+                               ['struct sk_buff *skb', 'struct genl_info *info'], suffix=';')
+
+        if 'dump' in op:
+            name = c_lower(f"{family.name}-{op_name}-dumpit")
+            cw.write_func_prot('int', name,
+                               ['struct sk_buff *skb', 'struct netlink_callback *cb'], suffix=';')
+    cw.nl()
+
+
+def print_kernel_op_table(family, cw):
+    print_kernel_op_table_fwd(family, cw, terminate=False)
+    for op_name, op in family.ops.items():
+        if op.is_async:
+            continue
+
+        cw.block_start()
+        cw.p(f".cmd = {op.enum_name},")
+        if 'dont-validate' in op:
+            cw.p(f".validate = {' | '.join([c_upper('genl-dont-validate-' + x) for x in op['dont-validate']])},")
+        for op_mode in ['do', 'dump']:
+            if op_mode in op:
+                name = c_lower(f"{family.name}-{op_name}-{op_mode}it")
+                cw.p(f".{op_mode}it = {name},")
+        if family.kernel_policy == 'per-op':
+            name = c_lower(f"{family.name}-{op_name}-policy")
+            cw.p(f".policy = {name},")
+        if 'flags' in op:
+            cw.p(f".flags = {' | '.join([c_upper('genl-' + x) for x in op['flags']])},")
+        cw.block_end(line=',')
+    cw.block_end(line=';')
+    cw.nl()
+
+
+def uapi_enum_start(family, cw, obj, ckey='', enum_name='enum-name'):
+    start_line = 'enum'
+    if enum_name in obj:
+        if obj[enum_name]:
+            start_line = 'enum ' + obj[enum_name].replace('-', '_')
+    elif ckey and ckey in obj:
+        start_line = 'enum ' + family.name + '_' + obj[ckey].replace('-', '_')
+    cw.block_start(line=start_line)
+
+
+def render_uapi(family, cw):
+    hdr_prot = f"_UAPI_LINUX_{family.name.upper()}_H"
+    cw.p('#ifndef ' + hdr_prot)
+    cw.p('#define ' + hdr_prot)
+    cw.nl()
+
+    fam_key = c_upper(family.get('c-family-name', family["name"] + '_FAMILY_NAME'))
+    ver_key = c_upper(family.get('c-version-name', family["name"] + '_FAMILY_VERSION'))
+    defines = [(fam_key, family["name"]),
+               (ver_key, family.get('version', 1))]
+    cw.writes_defines(defines)
+    cw.nl()
+
+    for const in family['definitions']:
+        if const['type'] == 'enum':
+            uapi_enum_start(family, cw, const, 'name')
+            first = True
+            for item in const['entries']:
+                suffix = ','
+                if first and 'value-start' in const:
+                    suffix = f" = {const['value-start']}" + suffix
+                first = False
+                item_name = item
+                if 'name-prefix' in const:
+                    item_name = c_upper(const['name-prefix'] + item)
+                cw.p(item_name + suffix)
+            cw.block_end(line=';')
+            cw.nl()
+        elif const['type'] == 'flags':
+            uapi_enum_start(family, cw, const, 'name')
+            i = const.get('value-start', 0)
+            for item in const['entries']:
+                item_name = item
+                if 'name-prefix' in const:
+                    item_name = c_upper(const['name-prefix'] + item)
+                cw.p(f'{item_name} = {1 << i},')
+                i += 1
+            cw.block_end(line=';')
+            cw.nl()
+
+    max_by_define = family.get('max-by-define', False)
+
+    for _, attr_set in family.attr_sets_list:
+        if attr_set.subset_of:
+            continue
+
+        cnt_name = c_upper(family.get('attr-cnt-name', f"__{attr_set.name_prefix}MAX"))
+        max_value = f"({cnt_name} - 1)"
+
+        val = 0
+        uapi_enum_start(family, cw, attr_set.yaml, 'enum-name')
+        for _, attr in attr_set.items():
+            suffix = ','
+            if attr['value'] != val:
+                suffix = f" = {attr['value']},"
+                val = attr['value']
+            val += 1
+            cw.p(attr.enum_name + suffix)
+        cw.nl()
+        cw.p(cnt_name + ('' if max_by_define else ','))
+        if not max_by_define:
+            cw.p(f"{attr_set.max_name} = {max_value}")
+        cw.block_end(line=';')
+        if max_by_define:
+            cw.p(f"#define {attr_set.max_name} {max_value}")
+        cw.nl()
+
+    # Commands
+    separate_ntf = 'async-prefix' in family['operations']
+
+    max_name = c_upper(family.get('cmd-max-name', f"{family.op_prefix}MAX"))
+    cnt_name = c_upper(family.get('cmd-cnt-name', f"__{family.op_prefix}MAX"))
+    max_value = f"({cnt_name} - 1)"
+
+    uapi_enum_start(family, cw, family['operations'], 'enum-name')
+    for _, op in family.ops_list:
+        if separate_ntf and ('notify' in op or 'event' in op):
+            continue
+
+        suffix = ','
+        if 'value' in op:
+            suffix = f" = {op['value']},"
+        cw.p(op.enum_name + suffix)
+    cw.nl()
+    cw.p(cnt_name + ('' if max_by_define else ','))
+    if not max_by_define:
+        cw.p(f"{max_name} = {max_value}")
+    cw.block_end(line=';')
+    if max_by_define:
+        cw.p(f"#define {max_name} {max_value}")
+    cw.nl()
+
+    if separate_ntf:
+        uapi_enum_start(family, cw, family['operations'], enum_name='async-enum')
+        for _, op in family.ops_list:
+            if separate_ntf and not ('notify' in op or 'event' in op):
+                continue
+
+            suffix = ','
+            if 'value' in op:
+                suffix = f" = {op['value']},"
+            cw.p(op.enum_name + suffix)
+        cw.block_end(line=';')
+        cw.nl()
+
+    # Multicast
+    grps = family.get('mcast-groups', {'list': []})
+    defines = []
+    for grp in grps['list']:
+        name = grp['name']
+        defines.append([c_upper(grp.get('c-define-name', f"{family.name}-mcgrp-{name}")),
+                        f'{name}'])
+    cw.nl()
+    if defines:
+        cw.writes_defines(defines)
+        cw.nl()
+
+    cw.p(f'#endif /* {hdr_prot} */')
+
+
+def find_kernel_root(full_path):
+    sub_path = ''
+    while True:
+        sub_path = os.path.join(os.path.basename(full_path), sub_path)
+        full_path = os.path.dirname(full_path)
+        maintainers = os.path.join(full_path, "MAINTAINERS")
+        if os.path.exists(maintainers):
+            return full_path, sub_path[:-1]
+
+
+def main():
+    parser = argparse.ArgumentParser(description='Netlink simple parsing generator')
+    parser.add_argument('--mode', dest='mode', type=str, required=True)
+    parser.add_argument('--spec', dest='spec', type=str, required=True)
+    parser.add_argument('--header', dest='header', action='store_true', default=None)
+    parser.add_argument('--source', dest='header', action='store_false')
+    parser.add_argument('--user-header', nargs='+', default=[])
+    args = parser.parse_args()
+
+    if args.header is None:
+        parser.error("--header or --source is required")
+
+    try:
+        parsed = Family(args.spec)
+    except yaml.YAMLError as exc:
+        print(exc)
+        os.sys.exit(1)
+        return
+
+    cw = CodeWriter(BaseNlLib())
+
+    _, spec_kernel = find_kernel_root(args.spec)
+    if args.mode == 'uapi':
+        cw.p('/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */')
+    else:
+        cw.p('// SPDX-License-Identifier: BSD-3-Clause')
+    cw.p("// Do not edit directly, auto-generated from:")
+    cw.p(f"//\t{spec_kernel}")
+    cw.p(f"// YNL-GEN {args.mode} {'header' if args.header else 'source'}")
+    cw.nl()
+
+    if args.mode == 'uapi':
+        render_uapi(parsed, cw)
+        return
+
+    hdr_prot = f"_LINUX_{parsed.name.upper()}_GEN_H"
+    if args.header:
+        cw.p('#ifndef ' + hdr_prot)
+        cw.p('#define ' + hdr_prot)
+        cw.nl()
+
+    if args.mode == 'kernel':
+        cw.p('#include <net/netlink.h>')
+        cw.p('#include <net/genetlink.h>')
+        cw.nl()
+        if not args.header:
+            cw.p(f'#include "{parsed.name}-nl.h"')
+            cw.nl()
+    headers = [parsed.uapi_header]
+    for definition in parsed['definitions']:
+        if 'header' in definition:
+            headers.append(definition['header'])
+    for one in headers:
+        cw.p(f"#include <{one}>")
+    cw.nl()
+
+    if args.mode == "user":
+        if not args.header:
+            cw.p("#include <stdlib.h>")
+            cw.p("#include <stdio.h>")
+            cw.p("#include <string.h>")
+            cw.p("#include <libmnl/libmnl.h>")
+            cw.p("#include <linux/genetlink.h>")
+            cw.nl()
+            for one in args.user_header:
+                cw.p(f'#include "{one}"')
+        else:
+            cw.p('struct ynl_sock;')
+        cw.nl()
+
+    if args.mode == "kernel":
+        if args.header:
+            if parsed.kernel_policy == 'global':
+                cw.p(f"// Global operation policy for {parsed.name}")
+
+                struct = Struct(parsed, parsed.global_policy_set, type_list=parsed.global_policy)
+                print_req_policy_fwd(cw, struct)
+                cw.nl()
+
+            for op_name, op in parsed.ops.items():
+                if parsed.kernel_policy == 'per-op' and 'do' in op and 'event' not in op:
+                    cw.p(f"// {op.enum_name} - do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    print_req_policy_fwd(cw, ri.struct['request'], op=op)
+                    cw.nl()
+
+            print_kernel_op_table_fwd(parsed, cw)
+        else:
+            if parsed.kernel_policy == 'global':
+                cw.p(f"// Global operation policy for {parsed.name}")
+
+                struct = Struct(parsed, parsed.global_policy_set, type_list=parsed.global_policy)
+                print_req_policy(cw, struct)
+                cw.nl()
+
+            for op_name, op in parsed.ops.items():
+                if parsed.kernel_policy == 'per-op':
+                    for op_mode in {'do', 'dump'}:
+                        if op_mode in op and 'request' in op[op_mode]:
+                            cw.p(f"// {op.enum_name} - {op_mode}")
+                            ri = RenderInfo(cw, parsed, args.mode, op, op_name, op_mode)
+                            print_req_policy(cw, ri.struct['request'], op=op)
+                            cw.nl()
+
+            print_kernel_op_table(parsed, cw)
+
+    if args.mode == "user":
+        has_ntf = False
+        if args.header:
+            cw.p('// Common nested types')
+            for attr_set, struct in sorted(parsed.pure_nested_structs.items()):
+                ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
+                print_type_full(ri, struct)
+
+            for op_name, op in parsed.ops.items():
+                cw.p(f"/* ============== {op.enum_name} ============== */")
+
+                if 'do' in op and 'event' not in op:
+                    cw.p(f"// {op.enum_name} - do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    print_req_type(ri)
+                    print_req_type_helpers(ri)
+                    cw.nl()
+                    print_rsp_type(ri)
+                    print_rsp_type_helpers(ri)
+                    cw.nl()
+                    print_req_prototype(ri)
+                    cw.nl()
+
+                if 'dump' in op:
+                    cw.p(f"// {op.enum_name} - dump")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'dump')
+                    if 'request' in op['dump']:
+                        print_req_type(ri)
+                        print_req_type_helpers(ri)
+                    if not ri.type_consistent:
+                        print_rsp_type(ri)
+                    print_wrapped_type(ri)
+                    print_dump_prototype(ri)
+                    cw.nl()
+
+                if 'notify' in op:
+                    cw.p(f"// {op.enum_name} - notify")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
+                    has_ntf = True
+                    if not ri.type_consistent:
+                        raise Exception('Only notifications with consistent types supported')
+                    print_wrapped_type(ri)
+
+                if 'event' in op:
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'event')
+                    cw.p(f"// {op.enum_name} - event")
+                    print_rsp_type(ri)
+                    cw.nl()
+                    print_wrapped_type(ri)
+
+            if has_ntf:
+                cw.p('// --------------- Common notification parsing --------------- //')
+                print_ntf_parse_prototype(parsed, cw)
+            cw.nl()
+        else:
+            cw.p('// Policies')
+            for name, _ in parsed.attr_sets.items():
+                struct = Struct(parsed, name)
+                put_typol_fwd(cw, struct)
+            cw.nl()
+
+            for name, _ in parsed.attr_sets.items():
+                struct = Struct(parsed, name)
+                put_typol(cw, struct)
+
+            cw.p('// Common nested types')
+            for attr_set, struct in sorted(parsed.pure_nested_structs.items()):
+                ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
+
+                free_rsp_nested(ri, struct)
+                if struct.request:
+                    put_req_nested(ri, struct)
+                if struct.reply:
+                    parse_rsp_nested(ri, struct)
+
+            for op_name, op in parsed.ops.items():
+                cw.p(f"/* ============== {op.enum_name} ============== */")
+                if 'do' in op and 'event' not in op:
+                    cw.p(f"// {op.enum_name} - do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    print_rsp_free(ri)
+                    parse_rsp_msg(ri)
+                    print_req(ri)
+                    cw.nl()
+
+                if 'dump' in op:
+                    cw.p(f"// {op.enum_name} - dump")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "dump")
+                    if not ri.type_consistent:
+                        parse_rsp_msg(ri, deref=True)
+                    print_dump_type_free(ri)
+                    print_dump(ri)
+                    cw.nl()
+
+                if 'notify' in op:
+                    cw.p(f"// {op.enum_name} - notify")
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
+                    has_ntf = True
+                    if not ri.type_consistent:
+                        raise Exception('Only notifications with consistent types supported')
+                    print_ntf_type_free(ri)
+
+                if 'event' in op:
+                    cw.p(f"// {op.enum_name} - event")
+                    has_ntf = True
+
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    parse_rsp_msg(ri)
+
+                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "event")
+                    print_ntf_type_free(ri)
+
+            if has_ntf:
+                cw.p('// --------------- Common notification parsing --------------- //')
+                print_ntf_type_parse(parsed, cw, args.mode)
+
+    if args.header:
+        cw.p(f'#endif /* {hdr_prot} */')
+
+
+if __name__ == "__main__":
+    main()
diff --git a/tools/net/ynl/ynl-regen.sh b/tools/net/ynl/ynl-regen.sh
new file mode 100755
index 000000000000..5664c60f0964
--- /dev/null
+++ b/tools/net/ynl/ynl-regen.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+# SPDX-License-Identifier: BSD-3-Clause
+
+TOOL=$(dirname $(realpath $0))/ynl-gen-c.py
+
+force=
+
+while [ ! -z "$1" ]; do
+  case "$1" in
+    -f ) force=yes; shift ;;
+    * )  echo "Unrecognized option '$1'"; exit 1 ;;
+  esac
+done
+
+KDIR=$(dirname $(dirname $(dirname $(dirname $(realpath $0)))))
+
+files=$(git grep --files-with-matches '^// YNL-GEN \(kernel\|uapi\)')
+for f in $files; do
+    # params:  0     1  2       3      4     5
+    #         // $YAML // YNL-GEN kernel $mode
+    params=( $(git grep -B1 -h '// YNL-GEN' $f) )
+
+    if [ $f -nt ${params[1]} -a -z "$force" ]; then
+	echo -e "\tSKIP $f"
+	continue
+    fi
+
+    echo -e "\tGEN ${params[4]}\t$f"
+    $TOOL --mode ${params[4]} --${params[5]} --spec $KDIR/${params[1]} > $f
+done
-- 
2.37.3

