Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9225170F90
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfGWDIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:48 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34307 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387881AbfGWDIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so30105768qkt.1
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 20:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O2LzIiKDY4d/HsG0eNgmi387YcnYg6wKjUrMRiQ2aBI=;
        b=cQVGQ4Lo+reBiq8dbjN5yriOzZVvY96vvAv9q8SsuYXMB9Uau30z5v7ourRopELAFV
         HrSuYt9L9h2jrveEkYTf5QYuw4n3uzgINqxIf9oaP4qrM3vxOSfbI/eyebdNEedw9sF9
         fnyXYmfKAQzMfGVsedovuQq8f4im3Cjf+KHSjHeyXl9m3EHsftdM5tHH+4KSxI9JW1Lm
         GX63sOgrwRVMD9cuOq0weGCDiiNaTCz17G7XnDt4HMCr7J7pvWTufHH7/U0V/19leICN
         5WI55ujo/WvPH3ihrWHlYoNRj8G0G/etpXi9XaiBLtfuQoiIQ3IH4houeVK4ZQbWq6us
         h5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O2LzIiKDY4d/HsG0eNgmi387YcnYg6wKjUrMRiQ2aBI=;
        b=Ga81PuyplnFAob7+YIfgayh29Lz6VsiRR7Cn2wx1a6Z55WhEARD+MF7bRraalZ6B6y
         fTKCSPNA2iWnpOynIAvfXJJz4XFTHNBnsWZailwvtUvsebCPVBK00Ja5CnScI9N1JOhN
         DAFC9HWQYwspD1DZDR5Gm5eqAn2GkFX5Vz7lkNHq/Dy2jrpJxHd1HbPJqyJUgOQhIQDN
         9nLuF6c3b/bP9ahaVGwFbFMdUZYzTkEeRzhRbMD7RyF1Vhf2fm5FKl3TdjGkuRfquu3z
         2oqJ1oAYlGlmRcQmdKCiGPegKa1YFoFiSCLwU2/5n7PTCQZClohloZGChed3e9KYcvlO
         h7Xg==
X-Gm-Message-State: APjAAAU9A1rzdmyPLqs9UeSBqPkeVZgfrPS5nwE1tNS9UCko00mquq27
        a+77edKBw6OrtiHSsTNj74nHGA==
X-Google-Smtp-Source: APXvYqyEMbHHfJqTE4TPKv38rNlMBE0t64ORiqa8pvqXPFdfxygujZ+CnHtEvxlGD+SsVbzsY099gA==
X-Received: by 2002:a37:a7d6:: with SMTP id q205mr46498779qke.44.1563851324361;
        Mon, 22 Jul 2019 20:08:44 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id x46sm26242144qtx.96.2019.07.22.20.08.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 20:08:43 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CAA2zVHqXDuMzBC6dD5AbepZc63nPdJ3WLYmjinjq01erqH+HXA@mail.gmail.com>
Date:   Mon, 22 Jul 2019 23:08:41 -0400
Cc:     David Miller <davem@davemloft.net>,
        Bill Wendling <morbo@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        natechancellor@gmail.com, Jakub Jelinek <jakub@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE0991D9-65E7-43CA-A4B4-D3547D96291A@lca.pw>
References: <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
 <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
 <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw>
 <20190718.162928.124906203979938369.davem@davemloft.net>
 <1563572871.11067.2.camel@lca.pw> <1563829996.11067.4.camel@lca.pw>
 <CAA2zVHqXDuMzBC6dD5AbepZc63nPdJ3WLYmjinjq01erqH+HXA@mail.gmail.com>
To:     James Y Knight <jyknight@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original issue,

=
https://lore.kernel.org/netdev/1562959401-19815-1-git-send-email-cai@lca.p=
w/

The debugging so far seems point to that the compilers get confused by =
the
module sections. During module_param(), it stores =
=E2=80=9C__param_rx_frag_size"
as a =E2=80=9Cstruct kernel_param=E2=80=9D into the __param section. =
Later, load_module()
obtains all =E2=80=9Ckernel_param=E2=80=9D from the __param section and =
compare against the
user-input module parameters from the command-line.  If there is a =
match, it
calls params[i].ops->set(&params[I]) to replace the value.  If compilers =
can=E2=80=99t
see that params[i].ops->set(&params[I]) could potentially change the =
value
of rx_frag_size, it will wrongly optimize it as a constant.


For example (it is not
compilable yet as I have not able to extract variable from the __param =
section
like find_module_sections()),

#include <stdio.h>
#include <string.h>

#define __module_param_call(name, ops, arg) \
        static struct kernel_param __param_##name \
         __attribute__ ((unused,__section__ =
("__param"),aligned(sizeof(void *)))) =3D { \
                #name, ops, { arg } }

struct kernel_param {
        const char *name;
        const struct kernel_param_ops *ops;
        union {
                int *arg;
        };
};

struct kernel_param_ops {
        int (*set)(const struct kernel_param *kp);
};

#define STANDARD_PARAM_DEF(name) \
        int param_set_##name(const struct kernel_param *kp) \
        { \
                *kp->arg =3D 2; \
        } \
        const struct kernel_param_ops param_ops_##name =3D { \
                .set =3D param_set_##name, \
        };

STANDARD_PARAM_DEF(ushort);
static int rx =3D 1;
__module_param_call(rx_frag_siz, &param_ops_ushort, &rx_frag_size);

int main(int argc, char *argv[])
{
        const struct kernel_param *params =3D <<< Get all kernel_param =
from the __param section >>>;
        int i;

        if (__builtin_constant_p(rx_frag_size))
                printf("rx_frag_size is a const.\n");

        for (i =3D 0; i < num_param; i++) {
                if (!strcmp(params[I].name, argv[1])) {
                        params[i].ops->set(&params[i]);
                        break;
                }
        }

        printf("rx_frag_size =3D %d\n", rx_frag_size);

        return 0;
}

