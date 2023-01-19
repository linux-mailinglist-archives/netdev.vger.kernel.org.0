Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D526743C3
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjASU4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjASUzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:55:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A1358C;
        Thu, 19 Jan 2023 12:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=IQwee1n/OucxpiUGuYFLaid9s14Kt471BO3AHHlwHzI=;
        t=1674161602; x=1675371202; b=bHbENoP/u68A54Fv/+qOEl4hlZwS3TRJT2diIlrYNVeqKj0
        7PsSzNvQ9QU7Yt7BJZoKcuRMrSt5ZiFj429TmfH+mw8iUxNG1LVW+tkZc79mbxA5el+cxRyn6XKwu
        mxVmdW4JhPIrrwP3t3AjZ7Bf4enHVRp7pJup84OX8Y61tahtEGZ1+536YOV4ixz6cqbAxmAKTZs/D
        nSoSrqLQ/8lYZ2tyyT+/bsr4EEHCdrrvuCI7Eb0Dq4L7Zd0kIUeDCBdxoedJvzSjqKrVzrLaEbti3
        4DYR6WAMVJNCLFCSCCPu0Mip3o+dtp0PWhPQuJDqj7loCxsO6ewdzEhv69q6VcRA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIbuL-006f9F-29;
        Thu, 19 Jan 2023 21:53:13 +0100
Message-ID: <ddcea8b3cb8c2d218a2747a1e2f566dbaaee8f01.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 3/8] net: add basic C code generators for
 Netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Date:   Thu, 19 Jan 2023 21:53:12 +0100
In-Reply-To: <20230119003613.111778-4-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
>=20
> +class BaseNlLib:
> +    def __init__(self):
> +        pass


That __init__ seems pointless?

> +        self.name =3D attr['name'].replace('-', '_')

You have a _lot_ of these ".replace('-', '_')" invocations - maybe make
a function just like you have c_upper()/c_lower()?

> +        if self.presence_type() =3D=3D 'len':
> +            pfx =3D '__' if space =3D=3D 'user' else ''

this is how you define pfx

> +        if member:
> +            ptr =3D ''
> +            if self. is_multi_val():
> +                ptr =3D '*'

but this is how you define ptr - feels a bit inconsistent

Also note the extra space after "self." there

> +        if not self.is_multi_val():
> +            ri.cw.p(f"if (ynl_attr_validate(yarg, attr))")
> +            ri.cw.p(f"return MNL_CB_ERROR;")

Those didn't need f-strings.

Does this "ri.cw.p()" do indentation for the code?


> +    def attr_policy(self, cw):
> +        if 'unterminated-ok' in self.checks and self.checks['unterminate=
d-ok']:

maybe

  if self.checks.get('unterminated-ok', 0):

> +class TypeBinary(Type):
> +    def arg_member(self, ri):
> +        return [f"const void *{self.c_name}", 'size_t len']
> +
> +    def presence_type(self):
> +        return 'len'
> +
> +    def struct_member(self, ri):
> +        ri.cw.p(f"void *{self.c_name};")
> +
> +    def _attr_typol(self):
> +        return f'.type =3D YNL_PT_BINARY,'
> +
> +    def _attr_policy(self, policy):
> +        mem =3D '{ '
> +        if len(self.checks) =3D=3D 1 and 'min-len' in self.checks:
> +            mem +=3D '.len =3D ' + str(self.checks['min-len'])

Why does the len(self.checks) matter?

> +        elif len(self.checks) =3D=3D 0:
> +            mem +=3D '.type =3D NLA_BINARY'
> +        else:
> +            raise Exception('Binary type not implemented, yet')

to get to that error messsage? The error messsage seems a bit misleading
too though. It's that 'max-len' isn't implemented, or such, no?

> +    def _complex_member_type(self, ri):
> +        if 'type' not in self.attr or self.attr['type'] =3D=3D 'nest':

could do

  if self.attr.get('type', 'nest') =3D=3D 'nest':

again like above

> +            return f"struct {self.nested_render_name}"
> +        elif self.attr['type'] in scalars:
> +            scalar_pfx =3D '__' if ri.ku_space =3D=3D 'user' else ''

You also have this

	... =3D '__' if ... =3D=3D 'user' else ''

quite a few times, maybe add something like

def qualify_user(value, user):
    if user =3D=3D 'user':
        return '__' + value
    return value

> +            return scalar_pfx + self.attr['type']

and then this is just

             return qualify_user(self.attr['type'], ri.ku_space)

instead of the two lines

> +    def free_needs_iter(self):
> +        return 'type' not in self.attr or self.attr['type'] =3D=3D 'nest=
'
> +
> +    def free(self, ri, var, ref):
> +        if 'type' not in self.attr or self.attr['type'] =3D=3D 'nest':

two more places that could use the .get trick

but it's really up to you. Just that the line like that seems rather
long to me :-)

There are many more below but I'll stop commenting.

> +        if self.c_name in c_kw:
> +            self.c_name +=3D '_'

You also have this pattern quite a lot. Maybe a "c_safe()" wrapper or
something :)

FWIW, I'm still looking for "c_kw", maybe "pythonically" that should be
"_C_KW" since it's a private global? I think? Haven't seen it yet :)


> +c_kw =3D {
> +    'do'
> +}


Aha, here it is :-)

> +            if has_ntf:
> +                cw.p('// --------------- Common notification parsing ---=
------------ //')

You said you were using /* */ comments now but this is still there.

> +                print_ntf_parse_prototype(parsed, cw)
> +            cw.nl()
> +        else:
> +            cw.p('// Policies')

and here too, etc.

Whew. I think I skipped some bits ;-)

Doesn't look that bad overall, IMHO. :)

johannes
