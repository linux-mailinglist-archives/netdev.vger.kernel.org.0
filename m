Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B49D5EB6F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfGCSSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:18:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:39512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbfGCSSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 14:18:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91152AE62;
        Wed,  3 Jul 2019 18:18:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DEA40E0159; Wed,  3 Jul 2019 20:18:51 +0200 (CEST)
Date:   Wed, 3 Jul 2019 20:18:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190703181851.GP20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703114933.GW2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 01:49:33PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:50:09PM CEST, mkubecek@suse.cz wrote:
> >diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
> >index 97c369aa290b..4636682c551f 100644
> >--- a/Documentation/networking/ethtool-netlink.txt
> >+++ b/Documentation/networking/ethtool-netlink.txt
> >@@ -73,6 +73,67 @@ set, the behaviour is the same as (or closer to) the behaviour before it was
> > introduced.
> > 
> > 
> >+Bit sets
> >+--------
> >+
> >+For short bitmaps of (reasonably) fixed length, standard NLA_BITFIELD32 type
> >+is used. For arbitrary length bitmaps, ethtool netlink uses a nested attribute
> >+with contents of one of two forms: compact (two binary bitmaps representing
> >+bit values and mask of affected bits) and bit-by-bit (list of bits identified
> >+by either index or name).
> >+
> >+Compact form: nested (bitset) atrribute contents:
> >+
> >+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
> >+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
> >+    ETHTOOL_A_BITSET_VALUE	(binary)	bitmap of bit values
> >+    ETHTOOL_A_BITSET_MASK	(binary)	bitmap of valid bits
> >+
> >+Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
> >+to a multiple of 32 bits. They consist of 32-bit words in host byte order,
> 
> Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
> nested array of NLA_BITFIELD32 instead?

That would mean a layout like

  4 bytes of attr header
  4 bytes of value
  4 bytes of mask
  4 bytes of attr header
  4 bytes of value
  4 bytes of mask
  ...

i.e. interleaved headers, words of value and words of mask. Having value
and mask contiguous looks cleaner to me. Also, I can quickly check the
sizes without iterating through a (potentially long) array.

> >+words ordered from least significant to most significant (i.e. the same way as
> >+bitmaps are passed with ioctl interface).
> >+
> >+For compact form, ETHTOOL_A_BITSET_SIZE and ETHTOOL_A_BITSET_VALUE are
> >+mandatory.  Similar to BITFIELD32, a compact form bit set requests to set bits
> 
> Double space^^

Hm, I have to learn how to tell vim not to do that with "gq".

> >+in the mask to 1 (if the bit is set in value) or 0 (if not) and preserve the
> >+rest. If ETHTOOL_A_BITSET_LIST is present, there is no mask and bitset
> >+represents a simple list of bits.
> 
> Okay, that is a bit confusing. Why not to rename to something like:
> ETHTOOL_A_BITSET_NO_MASK (flag)
> ?

From the logical point of view, it's used for lists - list of link
modes, list of netdev features, list of timestamping modes etc.

The point is that in userspace requests, we sometimes want to change
some values (enable A, disable B), sometimes to define the list of
values to be set (I want (only) A, C and E to be enabled). In kernel
replies, sometimes there is a natural value/mask pairing (e.g.
advertised and supported link modes, enabled and supported WoL modes)
but often there is just one bitmap.

> >+Kernel bit set length may differ from userspace length if older application is
> >+used on newer kernel or vice versa. If userspace bitmap is longer, an error is
> >+issued only if the request actually tries to set values of some bits not
> >+recognized by kernel.
> >+
> >+Bit-by-bit form: nested (bitset) attribute contents:
> >+
> >+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
> >+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
> >+    ETHTOOL_A_BITSET_BIT	(nested)	array of bits
> >+	ETHTOOL_A_BITSET_BIT+   (nested)	one bit
> >+	    ETHTOOL_A_BIT_INDEX	(u32)		bit index (0 for LSB)
> >+	    ETHTOOL_A_BIT_NAME	(string)	bit name
> >+	    ETHTOOL_A_BIT_VALUE	(flag)		present if bit is set
> >+
> >+Bit size is optional for bit-by-bit form. ETHTOOL_A_BITSET_BITS nest can only
> >+contain ETHTOOL_A_BITS_BIT attributes but there can be an arbitrary number of
> >+them.  A bit may be identified by its index or by its name. When used in
> >+requests, listed bits are set to 0 or 1 according to ETHTOOL_A_BIT_VALUE, the
> >+rest is preserved. A request fails if index exceeds kernel bit length or if
> >+name is not recognized.
> >+
> >+When ETHTOOL_A_BITSET_LIST flag is present, bitset is interpreted as a simple
> >+bit list. ETHTOOL_A_BIT_VALUE attributes are not used in such case. Bit list
> >+represents a bitmap with listed bits set and the rest zero.
> >+
> >+In requests, application can use either form. Form used by kernel in reply is
> >+determined by a flag in flags field of request header. Semantics of value and
> >+mask depends on the attribute. General idea is that flags control request
> >+processing, info_mask control which parts of the information are returned in
> >+"get" request and index identifies a particular subcommand or an object to
> >+which the request applies.
> 
> This is quite complex and confusing. Having the same API for 2 APIs is
> odd. The API should be crystal clear, easy to use.
> 
> Why can't you have 2 commands, one working with bit arrays only, one
> working with strings? Something like:
> X_GET
>    ETHTOOL_A_BITS (nested)
>       ETHTOOL_A_BIT_ARRAY (BITFIELD32)
> X_NAMES_GET
>    ETHTOOL_A_BIT_NAMES (nested)
> 	ETHTOOL_A_BIT_INDEX
> 	ETHTOOL_A_BIT_NAME
> 
> For set, you can also have multiple cmds:
> X_SET  - to set many at once, by bit index
>    ETHTOOL_A_BITS (nested)
>       ETHTOOL_A_BIT_ARRAY (BITFIELD32)
> X_ONE_SET   - to set one, by bit index
>    ETHTOOL_A_BIT_INDEX
>    ETHTOOL_A_BIT_VALUE
> X_ONE_SET   - to set one, by name
>    ETHTOOL_A_BIT_NAME
>    ETHTOOL_A_BIT_VALUE

This looks as if you assume there is nothing except the bitset in the
message but that is not true. Even with your proposed breaking of
current groups, you would still have e.g. 4 bitsets in reply to netdev
features query, 3 in timestamping info GET request and often bitsets
combined with other data (e.g. WoL modes and optional WoL password).
If you wanted to further refine the message granularity to the level of
single parameters, we might be out of message type ids already.

Unless you want to forget about structured data completely and turn
everything into tunables - but that's rather scary idea.

Michal
