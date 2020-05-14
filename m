Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA991D41CC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgENXnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:43:31 -0400
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:36744 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728415AbgENXna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 19:43:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 5EDA418029D8F;
        Thu, 14 May 2020 23:43:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2828:2892:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4050:4119:4250:4321:4605:5007:6119:6742:7903:9036:10004:10848:11026:11232:11473:11657:11658:11914:12043:12109:12296:12297:12438:12555:12740:12760:12895:12986:13255:13439:14093:14096:14097:14659:21063:21080:21433:21451:21627:21972:21990:30030:30034:30054:30075:30080:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: face85_754dbffefb147
X-Filterd-Recvd-Size: 8593
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 14 May 2020 23:43:25 +0000 (UTC)
Message-ID: <28145b05ee792b89ab9cb560f4f9989fd3d5d93b.camel@perches.com>
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
From:   Joe Perches <joe@perches.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Date:   Thu, 14 May 2020 16:43:24 -0700
In-Reply-To: <397fb29abb20d11003a18919ee0c44918fc1a165.camel@perches.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
         <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
         <1b63a6b193073674b6e0f9f95c62ce2af1b977cc.camel@perches.com>
         <CAADnVQK8osy9W8-u-K=ucqe5q-+Uik41fBw6d-SfG-m6rgVwDQ@mail.gmail.com>
         <397fb29abb20d11003a18919ee0c44918fc1a165.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-13 at 16:22 -0700, Joe Perches wrote:
> On Wed, 2020-05-13 at 16:07 -0700, Alexei Starovoitov wrote:
> > On Wed, May 13, 2020 at 4:05 PM Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2020-05-12 at 06:56 +0100, Alan Maguire wrote:
> > > > printk supports multiple pointer object type specifiers (printing
> > > > netdev features etc).  Extend this support using BTF to cover
> > > > arbitrary types.  "%pT" specifies the typed format, and the pointer
> > > > argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> > > > 
> > > > struct btf_ptr {
> > > >       void *ptr;
> > > >       const char *type;
> > > >       u32 id;
> > > > };
> > > > 
> > > > Either the "type" string ("struct sk_buff") or the BTF "id" can be
> > > > used to identify the type to use in displaying the associated "ptr"
> > > > value.  A convenience function to create and point at the struct
> > > > is provided:
> > > > 
> > > >       printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > > > 
> > > > When invoked, BTF information is used to traverse the sk_buff *
> > > > and display it.  Support is present for structs, unions, enums,
> > > > typedefs and core types (though in the latter case there's not
> > > > much value in using this feature of course).
> > > > 
> > > > Default output is indented, but compact output can be specified
> > > > via the 'c' option.  Type names/member values can be suppressed
> > > > using the 'N' option.  Zero values are not displayed by default
> > > > but can be using the '0' option.  Pointer values are obfuscated
> > > > unless the 'x' option is specified.  As an example:
> > > > 
> > > >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > > >   pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > > > 
> > > > ...gives us:
> > > > 
> > > > (struct sk_buff){
> > > >  .transport_header = (__u16)65535,
> > > >        .mac_header = (__u16)65535,
> > > >  .end = (sk_buff_data_t)192,
> > > >  .head = (unsigned char *)000000006b71155a,
> > > >  .data = (unsigned char *)000000006b71155a,
> > > >  .truesize = (unsigned int)768,
> > > >  .users = (refcount_t){
> > > >   .refs = (atomic_t){
> > > >    .counter = (int)1,
> > > 
> > > Given
> > > 
> > >   #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
> > > 
> > > Maybe
> > > 
> > >   #define BTF_INT_SIGNED  (1 << 0)
> > >   #define BTF_INT_CHAR    (1 << 1)
> > >   #define BTF_INT_BOOL    (1 << 2)
> > > 
> > > could be extended to include
> > > 
> > >   #define BTF_INT_HEX     (1 << 3)
> > > 
> > > So hex values can be appropriately pretty-printed.
> > 
> > Nack to that.
> 
> why?
> 

Tell me what's wrong with the idea.

Here's a possible implementation:
---
 Documentation/bpf/btf.rst      |  5 +++--
 include/uapi/linux/btf.h       |  1 +
 kernel/bpf/btf.c               |  5 ++++-
 tools/bpf/bpftool/btf.c        |  2 ++
 tools/bpf/bpftool/btf_dumper.c | 13 +++++++++++++
 tools/include/uapi/linux/btf.h |  1 +
 6 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 4d565d202ce3..56aaa189e7fb 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -139,10 +139,11 @@ The ``BTF_INT_ENCODING`` has the following attributes::
   #define BTF_INT_SIGNED  (1 << 0)
   #define BTF_INT_CHAR    (1 << 1)
   #define BTF_INT_BOOL    (1 << 2)
+  #define BTF_INT_HEX     (1 << 3)
 
 The ``BTF_INT_ENCODING()`` provides extra information: signedness, char, or
-bool, for the int type. The char and bool encoding are mostly useful for
-pretty print. At most one encoding can be specified for the int type.
+bool, for the int type. The char, bool and hex encodings are mostly useful
+for pretty print. At most one encoding can be specified for the int type.
 
 The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
 type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 5a667107ad2c..36f309209786 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -90,6 +90,7 @@ struct btf_type {
 #define BTF_INT_SIGNED	(1 << 0)
 #define BTF_INT_CHAR	(1 << 1)
 #define BTF_INT_BOOL	(1 << 2)
+#define BTF_INT_HEX	(1 << 3)
 
 /* BTF_KIND_ENUM is followed by multiple "struct btf_enum".
  * The exact number of btf_enum is stored in the vlen (of the
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1d4808..90bdc0635321 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -501,6 +501,8 @@ static const char *btf_int_encoding_str(u8 encoding)
 		return "CHAR";
 	else if (encoding == BTF_INT_BOOL)
 		return "BOOL";
+	else if (encoding == BTF_INT_HEX)
+		return "HEX";
 	else
 		return "UNKN";
 }
@@ -1404,7 +1406,8 @@ static s32 btf_int_check_meta(struct btf_verifier_env *env,
 	if (encoding &&
 	    encoding != BTF_INT_SIGNED &&
 	    encoding != BTF_INT_CHAR &&
-	    encoding != BTF_INT_BOOL) {
+	    encoding != BTF_INT_BOOL &&
+	    encoding != BTF_INT_HEX) {
 		btf_verifier_log_type(env, t, "Unsupported encoding");
 		return -ENOTSUPP;
 	}
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 41a1346934a1..44a129c40873 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -59,6 +59,8 @@ static const char *btf_int_enc_str(__u8 encoding)
 		return "CHAR";
 	case BTF_INT_BOOL:
 		return "BOOL";
+	case BTF_INT_HEX:
+		return "HEX";
 	default:
 		return "UNKN";
 	}
diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index ede162f83eea..96947ef92565 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -418,6 +418,19 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 	case BTF_INT_BOOL:
 		jsonw_bool(jw, *(int *)data);
 		break;
+	case BTF_INT_HEX:
+		if (BTF_INT_BITS(*int_type) == 64)
+			jsonw_printf(jw, "%llx", *(long long *)data);
+		else if (BTF_INT_BITS(*int_type) == 32)
+			jsonw_printf(jw, "%x", *(int *)data);
+		else if (BTF_INT_BITS(*int_type) == 16)
+			jsonw_printf(jw, "%hx", *(short *)data);
+		else if (BTF_INT_BITS(*int_type) == 8)
+			jsonw_printf(jw, "%hhx", *(char *)data);
+		else
+			btf_dumper_int_bits(*int_type, bit_offset, data, jw,
+					    is_plain_text);
+		break;
 	default:
 		/* shouldn't happen */
 		return -EINVAL;
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 5a667107ad2c..36f309209786 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -90,6 +90,7 @@ struct btf_type {
 #define BTF_INT_SIGNED	(1 << 0)
 #define BTF_INT_CHAR	(1 << 1)
 #define BTF_INT_BOOL	(1 << 2)
+#define BTF_INT_HEX	(1 << 3)
 
 /* BTF_KIND_ENUM is followed by multiple "struct btf_enum".
  * The exact number of btf_enum is stored in the vlen (of the


