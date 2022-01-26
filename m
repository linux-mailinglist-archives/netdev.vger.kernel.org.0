Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C74C49CF0E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiAZQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiAZQAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:00:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E162C06161C;
        Wed, 26 Jan 2022 08:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C079CB81F03;
        Wed, 26 Jan 2022 15:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E9CC340E6;
        Wed, 26 Jan 2022 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643212798;
        bh=X+RmX5LveR/DElha+H9g+z55A6Rjf/XcNDFPYxv/WHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nWldkKNrXR+KFVYNGhlWGOo0277tEiT3oaCIKp3KoD/Ux7kulKTIzau9dhz3Dgx+r
         jmS8Y9zjmJpEFfJduRqsoZg0jqGJ96f7XXfaKMUo8e+v4PLuY6fm7QbSLg5siQ6gHk
         n6cwv99n7eNy45xPNXt5FubG7ffOczJ+2y68v57Bacorf3/ajYTWeD5l4I6Dplf/yd
         QfhbDhcnS0TGGtcihwq+gYRO1tVi6TAvpo8jOufEVsGAuY6WRV3HvQUj6j+FTZtwDw
         /o+G1tckj1rPi0u9tpI7OunrCnDmc3rNVKoR+aynKTd0J38NDy+TlVa3rqNpUZ2its
         yCGHK5c0jVe4w==
Date:   Thu, 27 Jan 2022 00:59:52 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 2/9] fprobe: Add ftrace based probe APIs
Message-Id: <20220127005952.42dd07ff5f275e61be638283@kernel.org>
In-Reply-To: <20220126115022.fda21a3face4e97684f5bab9@kernel.org>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311271777.1933078.9066058105807126444.stgit@devnote2>
        <YfAoMW6i4gqw2Na0@krava>
        <YfA9aC5quQNc89Hc@krava>
        <20220126115022.fda21a3face4e97684f5bab9@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 11:50:22 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > one more question..
> > 
> > I'm adding support for user to pass function symbols to bpf fprobe link
> > and I thought I'd pass symbols array to register_fprobe, but I'd need to
> > copy the whole array of strings from user space first, which could take
> > lot of memory considering attachment of 10k+ functions
> > 
> > so I'm thinking better way is to resolve symbols already in bpf fprobe
> > link code and pass just addresses to register_fprobe
> 
> That is OK. Fprobe accepts either ::syms or ::addrs.
> 
> > 
> > I assume you want to keep symbol interface, right? could we have some
> > flag ensuring the conversion code is skipped, so we don't go through
> > it twice?
> 
> Yeah, we still have many unused bits in fprobe::flags. :)

Instead of that, according to Steve's comment, I would like to introduce
3 registration APIs.

int register_fprobe(struct fprobe *fp, const char *filter, const char *notrace);
int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num);
int register_fprobe_syms(struct fprobe *fp, const char **syms, int num);

The register_fprobe_ips() will not touch the @addrs. You have to set the
correct ftrace location address in the @addrs.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
