Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28969198851
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgC3Xaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:30:30 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:43126 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgC3Xa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:30:29 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 19:30:27 EDT
Received: from lubuntu-18.04 ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with SMTP id 02UNNqSq015827;
        Tue, 31 Mar 2020 01:23:58 +0200
Date:   Tue, 31 Mar 2020 01:23:48 +0200
From:   Stefano Salsano <stefano.salsano@uniroma2.it>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, bpf@vger.kernel.org,
        paolo.lungaroni@cnit.it, ahmed.abdelsalam@gssi.it,
        stefano.salsano@uniroma2.it
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
Message-Id: <20200331012348.e0b2373bd4a96fecc77686b6@uniroma2.it>
In-Reply-To: <20200325.193016.1654692564933635575.davem@davemloft.net>
References: <20200319183641.29608-1-andrea.mayer@uniroma2.it>
        <20200325.193016.1654692564933635575.davem@davemloft.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 19:30:16 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrea Mayer <andrea.mayer@uniroma2.it>
> Date: Thu, 19 Mar 2020 19:36:41 +0100
> 
> > Messy code and complicated tricks may arise from this approach.
> 
> People taking advantage of this new flexibility will write
> applications that DO NOT WORK on older kernels.
> 
> I think we are therefore stuck with the current optional attribute
> semantics, sorry.

Dear David,

sorry we have provided this patch without giving enough context. 

We are planning several enhancements to the SRv6 kernel implementation to keep
it aligned with the IETF standardization evolution and to add important
features like monitoring (some examples below). So far, the implemented SRv6
behaviors require few mandatory attributes and the code has been implemented in
a naive way following this requirement. We believe it is important to overcome
the limitations of this implementation considering the requirements coming from
new SRv6 behaviors and features shown in the examples below.

To provide 100% backward compatibility, we are not going to use the proposed
optional attribute semantic on any of the currently defined attributes, so
there is no risk to write applications using the existing attributes that will
not work on older kernels, which is (wisely) your main concern. 

Of course a new application (e.g. iproute2, pyroute) using a new optional
parameter will not work on older kernels, but simply because the new parameter
is not supported. It will not work even without our proposed patch.

On the other hand, we think that the solution in the patch is more backward
compatible. Without the patch, if we define new attributes, old applications
(e.g. iproute2 scripts) will not work on newer kernels, while with the optional
attributes approach proposed in the patch they will work with no issues !

In the light of the above clarification, what is your opinion?

Hereafter we list the SRv6 use cases that benefit from the proposed patch. We
have patches that implement these use cases, do you think that we should submit
one or two of them to show how we use the optional parameters?

Thank you for your attention!
Stefano

4 examples of enhancements to SRv6 that require optional parameters

1) Enhancement to End.DX4 behavior to support explicit indication of outgoing
device: "oif" parameter used as optional in the context of End.DX4 behavior

 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 oif eth1 dev eth0

2) Statistics (per behavior counting of packets/bytes/errors) : new "stats"
parameter used as optional in the context of any behavior

 ip -6 route add 2001:db8::1 encap seg6local action End.DT6 table 100 dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End.DT6 table 100 stats dev eth0
 
 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 stats dev eth0
 
 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 oif eth1 dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End.DX4 nh4 1.2.3.4 oif eth1 stats dev eth0

3) Flavors (as per sec. 4.16 of draft-ietf-spring-srv6-network-programming-14):
new "flavors" parameter used as optional in the context of End, End.X, End.T

 ip -6 route add 2001:db8::1 encap seg6local action End dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End flavors PSP dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End flavors USP dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End flavors USD dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End flavors PSP,USP,USD dev eth0
 
 ip -6 route add 2001:db8::1 encap seg6local action End.T table 100 dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action End.T table 100 flavors USP dev eth0

4) micro SID (draft-filsfils-spring-net-pgm-extension-srv6-usid-04): in the
context of the new behavior uN, new optional parameters "ubl" and "ul"

 ip -6 route add 2001:db8::1 encap seg6local action uN dev eth0
 ip -6 route add 2001:db8::1 encap seg6local action uN ubl 32 ul 16 dev eth0


-- 
*******************************************************************
Stefano Salsano
Professore Associato
Dipartimento Ingegneria Elettronica
Universita' di Roma Tor Vergata
Viale Politecnico, 1 - 00133 Roma - ITALY

http://netgroup.uniroma2.it/Stefano_Salsano/

E-mail  : stefano.salsano@uniroma2.it
Cell.   : +39 320 4307310
Office  : (Tel.) +39 06 72597770 (Fax.) +39 06 72597435
*******************************************************************
