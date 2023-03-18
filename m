Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A5D6BF7CB
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCREuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCREup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:50:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB93367E7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDD7EB826D2
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369C4C433EF;
        Sat, 18 Mar 2023 04:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679115039;
        bh=gtIrAN0zc+vnAz109zQ1BkX7+hHD2S8R53qgzGsI2VA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BVsUn3jrKCoOfiIdSRSJPxP4eemNp8CRWhRWOea3MaMKy0M/DjlZvlG2OLu29a9qS
         aHvXcqVnR3HJXUD53WDAUTX1slISJq5asU6CGbYK3buiELOGZMKsCN0F5Dcxw196wd
         JkVusCmpROn38ERqfRD9iwPVCcLTZ++uIMeXGMMjpv/Lzvaf5y0c0hu4fmIfJ01zyx
         ERvfV3jyJ+cKVWsZxajPovwf7qK0eJ0iIX+dYxzj5oTLmQ+G/1jRxM/7wCtbG9Pyre
         0+JV1KuaaHpibJRxjLSnYmEH9XF6ajfBmbpy/XA2VtCSK9KTn7qBwBIcGrRsAn6mS6
         XFkU6W88Lqgow==
Date:   Fri, 17 Mar 2023 21:50:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1 1/2] tools: ynl: add user-header and struct
 attr support
Message-ID: <20230317215038.71ed63d7@kernel.org>
In-Reply-To: <20230316120142.94268-2-donald.hunter@gmail.com>
References: <20230316120142.94268-1-donald.hunter@gmail.com>
        <20230316120142.94268-2-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 12:01:41 +0000 Donald Hunter wrote:
> Subject: [PATCH net-next v1 1/2] tools: ynl: add user-header and struct attr support

The use of "and" usually indicates it should be 2 separate patches ;)

> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  Documentation/netlink/genetlink-legacy.yaml | 10 +++-
>  tools/net/ynl/lib/ynl.py                    | 58 ++++++++++++++++++---
>  2 files changed, 60 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
> index c6b8c77f7d12..7f019c0a9762 100644
> --- a/Documentation/netlink/genetlink-legacy.yaml
> +++ b/Documentation/netlink/genetlink-legacy.yaml
> @@ -53,6 +53,9 @@ properties:
>        Defines if the input policy in the kernel is global, per-operation, or split per operation type.
>        Default is split.
>      enum: [ split, per-op, global ]
> +  user-header:
> +    description: Name of the struct definition for the user header for the family.
> +    type: string

Took me a minute to remember this is header as in protocol header 
not header as in C header file :) Would it possibly be better to call it
fixed-header ? Can't really decide myself.

But the description definitely need to be more verbose:

description: |
  Name of the structure defining the fixed-length protocol header.
  This header is placed in a message after the netlink and genetlink
  headers and before any attributes.

>    # End genetlink-legacy
>  
>    definitions:
> @@ -172,7 +175,7 @@ properties:
>                  type: string
>                type: &attr-type
>                  enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> -                        string, nest, array-nest, nest-type-value ]
> +                        string, nest, array-nest, nest-type-value, struct ]
>                doc:
>                  description: Documentation of the attribute.
>                  type: string
> @@ -218,6 +221,11 @@ properties:
>                      description: Max length for a string or a binary attribute.
>                      $ref: '#/$defs/len-or-define'
>                sub-type: *attr-type
> +              # Start genetlink-legacy
> +              struct:
> +                description: Name of the struct type used for the attribute.
> +                type: string
> +              # End genetlink-legacy
>  
>        # Make sure name-prefix does not appear in subsets (subsets inherit naming)
>        dependencies:
> diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> index 90764a83c646..584b1e0a6b2f 100644
> --- a/tools/net/ynl/lib/ynl.py
> +++ b/tools/net/ynl/lib/ynl.py
> @@ -68,6 +68,11 @@ class Netlink:
>  
>  
>  class NlAttr:
> +    type_formats = { 'u8' : ('B', 1),
> +                     'u16': ('H', 2),
> +                     'u32': ('I', 4),
> +                     'u64': ('Q', 8) }
> +
>      def __init__(self, raw, offset):
>          self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
>          self.type = self._type & ~Netlink.NLA_TYPE_MASK
> @@ -93,6 +98,21 @@ class NlAttr:
>      def as_bin(self):
>          return self.raw
>  
> +    def as_array(self, type):
> +        format, _ = self.type_formats[type]
> +        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })

The Python is strong within you :)

> +    def as_struct(self, members):
> +        value = dict()
> +        offset = 0
> +        for m in members:
> +            type = m['type']

Accessing the spec components directly is a bit of an anti-pattern,
can we parse the struct description into Python objects in
tools/net/ynl/lib/nlspec.py ?

> +            format, size = self.type_formats[type]
> +            decoded = struct.unpack_from(format, self.raw, offset)
> +            offset += size
> +            value[m['name']] = decoded[0]
> +        return value
> +
>      def __repr__(self):
>          return f"[type:{self.type} len:{self._len}] {self.raw}"
>  
> @@ -200,7 +220,7 @@ def _genl_msg(nl_type, nl_flags, genl_cmd, genl_version, seq=None):
>      if seq is None:
>          seq = random.randint(1, 1024)
>      nlmsg = struct.pack("HHII", nl_type, nl_flags, seq, 0)
> -    genlmsg = struct.pack("bbH", genl_cmd, genl_version, 0)
> +    genlmsg = struct.pack("BBH", genl_cmd, genl_version, 0)

Should also be a separate patch

>      return nlmsg + genlmsg
>  
>  
> @@ -258,14 +278,22 @@ def _genl_load_families():
>  
>  
>  class GenlMsg:
> -    def __init__(self, nl_msg):
> +    def __init__(self, nl_msg, extra_headers = []):
>          self.nl = nl_msg
>  
>          self.hdr = nl_msg.raw[0:4]
> -        self.raw = nl_msg.raw[4:]
> +        offset = 4
>  
> -        self.genl_cmd, self.genl_version, _ = struct.unpack("bbH", self.hdr)
> +        self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
>  
> +        self.user_attrs = dict()
> +        for m in extra_headers:
> +            format, size = NlAttr.type_formats[m['type']]
> +            decoded = struct.unpack_from(format, nl_msg.raw, offset)
> +            offset += size
> +            self.user_attrs[m['name']] = decoded[0]


user_attrs?

> +        self.raw = nl_msg.raw[offset:]
>          self.raw_attrs = NlAttrs(self.raw)
>  
>      def __repr__(self):
> @@ -315,6 +343,7 @@ class YnlFamily(SpecFamily):
>              setattr(self, op.ident_name, bound_f)
>  
>          self.family = GenlFamily(self.yaml['name'])
> +        self._user_header = self.yaml.get('user-header', None)
>  
>      def ntf_subscribe(self, mcast_name):
>          if mcast_name not in self.family.genl_family['mcast']:
> @@ -358,7 +387,7 @@ class YnlFamily(SpecFamily):
>                  raw >>= 1
>                  i += 1
>          else:
> -            value = enum['entries'][raw - i]
> +            value = enum.entries_by_val[raw - i]['name']

Also a separate fix :S

>          rsp[attr_spec['name']] = value
>  
>      def _decode(self, attrs, space):
> @@ -381,6 +410,14 @@ class YnlFamily(SpecFamily):
>                  decoded = attr.as_bin()
>              elif attr_spec["type"] == 'flag':
>                  decoded = True
> +            elif attr_spec["type"] == 'struct':
> +                s = attr_spec['struct']
> +                decoded = attr.as_struct(self.consts[s]['members'])
> +            elif attr_spec["type"] == 'array-nest':
> +                decoded = attr.as_array(attr_spec["sub-type"])
> +            elif attr_spec["type"] == 'unused':
> +                print(f"Warning: skipping unused attribute {attr_spec['name']}")
> +                continue
>              else:
>                  raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
>  
> @@ -472,6 +509,13 @@ class YnlFamily(SpecFamily):
>  
>          req_seq = random.randint(1024, 65535)
>          msg = _genl_msg(self.family.family_id, nl_flags, op.req_value, 1, req_seq)
> +        user_headers = []
> +        if self._user_header:
> +            user_headers = self.consts[self._user_header]['members']
> +            for m in user_headers:
> +                value = vals.pop(m['name'])
> +                format, _ = NlAttr.type_formats[m['type']]
> +                msg += struct.pack(format, value)
>          for name, value in vals.items():
>              msg += self._add_attr(op.attr_set.name, name, value)
>          msg = _genl_msg_finalize(msg)
> @@ -498,7 +542,7 @@ class YnlFamily(SpecFamily):
>                      done = True
>                      break
>  
> -                gm = GenlMsg(nl_msg)
> +                gm = GenlMsg(nl_msg, user_headers)
>                  # Check if this is a reply to our request
>                  if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
>                      if gm.genl_cmd in self.async_msg_ids:
> @@ -508,7 +552,7 @@ class YnlFamily(SpecFamily):
>                          print('Unexpected message: ' + repr(gm))
>                          continue
>  
> -                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
> +                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.user_attrs)
>  
>          if not rsp:
>              return None

