Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D87B19CAFF
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 22:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgDBUWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 16:22:01 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:46323 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgDBUWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 16:22:01 -0400
Received: by mail-pl1-f175.google.com with SMTP id s23so1754901plq.13;
        Thu, 02 Apr 2020 13:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8QzNQ6U5mR4yP2Jfvx22V6HOyGsI4et+ZabZoYVq6ow=;
        b=CWfAV6mcEmSnaXuR1eS0tmRtyjrOw5tBbLcyJNHMYijkScJlg37lvXIHajdOZV0eX0
         WjJ6pgrc79KETLmojLxB7KvOz0dcuS5oZowS03QXjNLTgG4A2kW8TtSwf+VRnegGU1Ce
         6SQtowayUghrDPjt0LDTGsrdniEbe48VGKZnbENhE2w+fhbVngjD9RE7Tt4a5q393ux4
         6hK1qQO/0Sz4F2op9/ANp+mYJycImugeTCiFtuLkpts+tO5QAQ24v333tzeY0GIyKRuH
         dqlfjB/83uXp9/8KdZDcCARai5kSyH7wEnVDZhLsod2lvU6eHPAMXsd1GpZyr3n54pT8
         Km+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8QzNQ6U5mR4yP2Jfvx22V6HOyGsI4et+ZabZoYVq6ow=;
        b=P0HoKQ0Z0RTJd2yzMXDhOrtenUaborcCOtn6AMczZG5TN3HsBWJSbyVm7Vf2x3Sn8M
         4ts9yFPcaH/yc9uWJ8gp6Cd05/0mwEBnL/FMf5ROsdKCCGlegqklPwtgB7rECRqtIHgQ
         BzQ95WY4jFRqZegQ+aif1rCo8P/3HmZN1RN1dGhxct7XvNNteFZRvQFG0IIspZVYaK2o
         0cPWjG98/B7S/55ydCCyNRzCwjVmjX0E/S0Ati86A2rWKUMvYJ4C1hcckF2S1xesk8+T
         dKo5lG7al+2LZeIp2uE5RSSDlsUq9ZryeLk2wImTy41c68aUYgasGYO2q8DL5YLqggPs
         14yg==
X-Gm-Message-State: AGi0PuaPdqtD1nWMitBc/fu43GF9IH4NV66mCsk+tH96qpDMjpX6m4ye
        uXMwMG1/fJw4lZ56EfGbZdE=
X-Google-Smtp-Source: APiQypJo0MuaPYS7zNpkTaNHnreB97PAhFJJKC7+AKHiFSqEA0PklWgkkDZ/T5SC7hXFsuL1B9D/qQ==
X-Received: by 2002:a17:902:7b89:: with SMTP id w9mr4751937pll.34.1585858919413;
        Thu, 02 Apr 2020 13:21:59 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b3a4])
        by smtp.gmail.com with ESMTPSA id c201sm4308362pfc.73.2020.04.02.13.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 13:21:58 -0700 (PDT)
Date:   Thu, 2 Apr 2020 13:21:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: bpf: ability to attach freplace to multiple parents
Message-ID: <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
References: <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8sim4rw.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:11:15PM +0100, Toke Høiland-Jørgensen wrote:
> 
> Current code is in [0], for those following along. There are two bits of
> kernel support missing before I can get it to where I want it for an
> initial "release": Atomic replace of the dispatcher (this series), and
> the ability to attach an freplace program to more than one "parent".
> I'll try to get an RFC out for the latter during the merge window, but
> I'll probably need some help in figuring out how to make it safe from
> the verifier PoV.

I have some thoughts on the second part "ability to attach an freplace
to more than one 'parent'".
I think the solution should be more generic than just freplace.
fentry/fexit need to have the same feature.
Few folks already said that they want to attach fentry to multiple
kernel functions. It's similar to what people do with kprobe progs now.
(attach to multiple and differentiate attach point based on parent IP)
Similarly "bpftool profile" needs it to avoid creating new pair of fentry/fexit
progs for every target bpf prog it's collecting stats about.
I didn't add this ability to fentry/fexit/freplace only to simplify
initial implementation ;) I think the time had come.
Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
It just needs to become a linked list.
The api extension could be like this:
bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
(currently it's just bpf_raw_tp_open(prog_fd))
The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
to hold the linked_prog and its corresponding btf_id.
I'm proposing to extend raw_tp_open with this pair as well to
attach existing fentry/fexit/freplace prog to another target.
Internally the kernel verify that btf of current linked_prog
exactly matches to btf of another requested linked_prog and
if they match it will attach the same prog to two target programs (in case of freplace)
or two kernel functions (in case of fentry/fexit).

Toke, Andrey,
if above kinda makes sense from high level description
I can prototype it quickly and then we can discuss details
in the patches ?
Or we can drill further into details and discuss corner cases.
