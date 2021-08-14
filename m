Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85EA3EBF06
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhHNAho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:37:44 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:40830 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHNAhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 20:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628901437; x=1660437437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2QkQ7D6KKoz51nnNwOW9EfIdFiY+r+AIPJp/zvMp9U=;
  b=Z74sHrJFgeOVNKc7XG0HcwqnDtia08RPDIXvYblhOIFWdCS0B2zEYiL6
   0Tr0MMTVIu+tmzdg9wDL8GBIja/90edEXaEavqLI+KWKO50QmxOO9QpNT
   442H4c0dHkzI41wEj/CjIm5jI6JmxBoBqousysfJ9P3UCzqG06NgMZ/0S
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="19217705"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Aug 2021 00:37:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 78335A1E84;
        Sat, 14 Aug 2021 00:37:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 00:37:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 00:37:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v5 bpf-next 4/4] selftest/bpf: Extend the bpf_snprintf() test for "%c".
Date:   Sat, 14 Aug 2021 09:37:02 +0900
Message-ID: <20210814003702.35395-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4Bzb-Y5SRrS6VHpBbosUj1QU+76zo29KOJF9-GBoJKaZhCQ@mail.gmail.com>
References: <CAEf4Bzb-Y5SRrS6VHpBbosUj1QU+76zo29KOJF9-GBoJKaZhCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D11UWC002.ant.amazon.com (10.43.162.174) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 16:30:29 -0700
> On Fri, Aug 13, 2021 at 4:28 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Aug 12, 2021 at 9:47 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > This patch adds a "positive" pattern for "%c", which intentionally uses a
> > > __u32 value (0x64636261, "dbca") to print a single character "a".  If the
> > > implementation went wrong, other 3 bytes might show up as the part of the
> > > latter "%+05s".
> > >
> > > Also, this patch adds two "negative" patterns for wide character.
> > >
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/snprintf.c | 4 +++-
> > >  tools/testing/selftests/bpf/progs/test_snprintf.c | 7 ++++---
> > >  2 files changed, 7 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > > index dffbcaa1ec98..f77d7def7fed 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > > @@ -19,7 +19,7 @@
> > >  #define EXP_ADDR_OUT "0000000000000000 ffff00000add4e55 "
> > >  #define EXP_ADDR_RET sizeof(EXP_ADDR_OUT "unknownhashedptr")
> > >
> > > -#define EXP_STR_OUT  "str1 longstr"
> > > +#define EXP_STR_OUT  "str1         a longstr"
> > >  #define EXP_STR_RET  sizeof(EXP_STR_OUT)
> > >
> > >  #define EXP_OVER_OUT "%over"
> > > @@ -114,6 +114,8 @@ void test_snprintf_negative(void)
> > >         ASSERT_ERR(load_single_snprintf("%"), "invalid specifier 3");
> > >         ASSERT_ERR(load_single_snprintf("%12345678"), "invalid specifier 4");
> > >         ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
> > > +       ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
> > > +       ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
> > >         ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
> > >         ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
> > >  }
> > > diff --git a/tools/testing/selftests/bpf/progs/test_snprintf.c b/tools/testing/selftests/bpf/progs/test_snprintf.c
> > > index e2ad26150f9b..afc2c583125b 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_snprintf.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_snprintf.c
> > > @@ -40,6 +40,7 @@ int handler(const void *ctx)
> > >         /* Convenient values to pretty-print */
> > >         const __u8 ex_ipv4[] = {127, 0, 0, 1};
> > >         const __u8 ex_ipv6[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
> > > +       const __u32 chr1 = 0x64636261; /* dcba */
> > >         static const char str1[] = "str1";
> > >         static const char longstr[] = "longstr";
> > >
> > > @@ -59,9 +60,9 @@ int handler(const void *ctx)
> > >         /* Kernel pointers */
> > >         addr_ret = BPF_SNPRINTF(addr_out, sizeof(addr_out), "%pK %px %p",
> > >                                 0, 0xFFFF00000ADD4E55, 0xFFFF00000ADD4E55);
> > > -       /* Strings embedding */
> > > -       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s %+05s",
> > > -                               str1, longstr);
> > > +       /* Strings and single-byte character embedding */
> > > +       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s % 9c %+05s",
> > > +                               str1, chr1, longstr);
> 
> Can you also add tests for %+2c, %-3c, %04c, %0c? Think outside the box ;)

Sure.


> > Why this hackery with __u32? You are making an endianness assumption
> > (it will break on big-endian), and you'd never write real code like
> > that. Just pass 'a', what's wrong with that?

In my first implementation of "%c" support, I tried to support "%lc" and
"%llc" also and reused the later int code.  Then just testing 'a' was ok,
but it was wrong with the 0x64636261, three bytes of which showed up as
part of the next %s.  So, I thought it would be better to test with int.
But exactly it breaks the big-endian case, I'll just pass 'a'.


> >
> > >         /* Overflow */
> > >         over_ret = BPF_SNPRINTF(over_out, sizeof(over_out), "%%overflow");
> > >         /* Padding of fixed width numbers */
> > > --
> > > 2.30.2
> > >
