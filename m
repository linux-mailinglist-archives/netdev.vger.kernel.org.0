Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB2734D449
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhC2Ptl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:49:41 -0400
Received: from forward101o.mail.yandex.net ([37.140.190.181]:53096 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229971AbhC2Pt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:49:28 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 11:49:28 EDT
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id 8E9EA3C02333;
        Mon, 29 Mar 2021 18:42:27 +0300 (MSK)
Received: from vla5-d4be149c9aa7.qloud-c.yandex.net (vla5-d4be149c9aa7.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3485:0:640:d4be:149c])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id 8996C3A20002;
        Mon, 29 Mar 2021 18:42:27 +0300 (MSK)
Received: from vla5-445dc1c4c112.qloud-c.yandex.net (vla5-445dc1c4c112.qloud-c.yandex.net [2a02:6b8:c18:3609:0:640:445d:c1c4])
        by vla5-d4be149c9aa7.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 3lcErtX31x-gRJiVU1h;
        Mon, 29 Mar 2021 18:42:27 +0300
Authentication-Results: vla5-d4be149c9aa7.qloud-c.yandex.net; dkim=pass
Received: by vla5-445dc1c4c112.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 2HMKqH1t4A-gQLeEWgX;
        Mon, 29 Mar 2021 18:42:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [BUG / question] in routing rules, some options (e.g. ipproto,
 sport) cause rules to be ignored in presence of packet marks
From:   Michal Soltys <msoltyspl@yandex.pl>
To:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
Message-ID: <6b707dde-c6f0-ca3e-e817-a09c1e6b3f00@yandex.pl>
Date:   Mon, 29 Mar 2021 17:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
Content-Type: multipart/mixed;
 boundary="------------73C4CFAC0A46D0A44A5509F9"
Content-Language: en-US-large
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------73C4CFAC0A46D0A44A5509F9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/21 4:05 PM, Michal Soltys wrote:
> Hi,
> 
> iptables -t mangle -A OUTPUT -j MARK --set-mark 1

After some extra checks, the exact same issue happens if we mangle tos 
instead of mark, so ...

iptables -t mangle -A OUTPUT -j TOS --set-tos 0x02

... will cause same routing issues with incorrect output interface being 
set.

Anyway, I've attached 2 scripts setting up namespace with all those cases.

- run setup-host.sh
- then in the namespace: run setup-namespace.sh
- fire up another bash in ns with tcpdump on right1

nc -u -p 1194 1.2.3.4 12345

This will work fine, as the packet will be routed correctly via right2, 
tcpdump will show nothing

Now add in the namespace:

iptables -t mangle -A OUTPUT -j MARK --set-mark 1

or

iptables -t mangle -A OUTPUT -j TOS --set-tos 0x02

Same nc as above - now the packet will go out via right1, using right2's 
address (initial routing decision).


Unrelated issue - while doing the tests I noticed that routing rules 
based on tos have no effect at all for locally generated packets. Will 
make another post about it though.

--------------73C4CFAC0A46D0A44A5509F9
Content-Type: application/x-shellscript;
 name="setup-namespace.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="setup-namespace.sh"

IyEvYmluL2Jhc2gKCmlwIGxpIHNldCBsbyB1cAppcCBhZGQgYWRkIDEwLjAuMTAuMi8yNCBk
ZXYgcmlnaHQxCmlwIGFkZCBhZGQgMTAuMC4yMC4yLzI0IGRldiByaWdodDIKaXAgbGkgc2V0
IHJpZ2h0MSB1cAppcCBsaSBzZXQgcmlnaHQyIHVwCmlwIHJvIGFkZCBkZWZhdWx0IHZpYSAx
MC4wLjEwLjEgZGV2IHJpZ2h0MQoKIyBzZXBhcmF0ZSB0YWJsZSByb3V0aW5nIHBhY2tldHMg
dmlhIHJpZ2h0MgppcCBybyBhZGQgZGVmYXVsdCB2aWEgMTAuMC4yMC4xIGRldiByaWdodDIg
c3JjIDEwLjAuMjAuMiB0YWJsZSAxMjMKCiMgcm91dGluZyBydWxlcyBkaXJlY3RpbmcgcGFj
a2V0cyB2aWEgdGFibGUgMTIzCmlwIHJ1IGFkZCBwcmVmIDEwIGlwcHJvdG8gdWRwIGxvb2t1
cCAxMjMKaXAgcnUgYWRkIHByZWYgMTEgc3BvcnQgMTE5NCBsb29rdXAgMTIzCmlwIHJ1IGFk
ZCBwcmVmIDEyIGRwb3J0IDEyMzQ1IGxvb2t1cCAxMjMKCiMgZm9yIHRlc3Rpbmc6CiMgaXB0
YWJsZXMgLXQgbWFuZ2xlIC1BIE9VVFBVVCAtaiBNQVJLIC0tc2V0LW1hcmsgMQojIGlwdGFi
bGVzIC10IG1hbmdsZSAtQSBPVVRQVVQgLWogVE9TIC0tc2V0LXRvcyAweDAyCg==
--------------73C4CFAC0A46D0A44A5509F9
Content-Type: application/x-shellscript;
 name="setup-host.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="setup-host.sh"

IyEvYmluL2Jhc2gKCmlwIG5ldG5zIGFkZCBydGVzdAppcCBsaW5rIGFkZCBuYW1lIGxlZnQx
IHR5cGUgdmV0aCBwZWVyIG5hbWUgcmlnaHQxIG5ldG5zIHJ0ZXN0CmlwIGxpbmsgYWRkIG5h
bWUgbGVmdDIgdHlwZSB2ZXRoIHBlZXIgbmFtZSByaWdodDIgbmV0bnMgcnRlc3QKaXAgYWQg
YWRkIDEwLjAuMTAuMS8yNCBkZXYgbGVmdDEKaXAgYWQgYWRkIDEwLjAuMjAuMS8yNCBkZXYg
bGVmdDIKaXAgbGkgc2V0IGxlZnQxIHVwCmlwIGxpIHNldCBsZWZ0MiB1cAo=
--------------73C4CFAC0A46D0A44A5509F9--
