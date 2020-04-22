Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B41B4B39
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgDVRD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:03:27 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4925 "EHLO
        esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgDVRD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:03:26 -0400
X-Greylist: delayed 1790 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2020 13:03:23 EDT
Received: from [10.68.100.236] (h10-gesig.woeg.acw.at [217.116.178.11] (may be forged))
        (authenticated bits=0)
        by esgaroth.tuxoid.at (8.15.2/8.15.2) with ESMTPSA id 03MGVYYO000469
        (version=TLSv1 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO);
        Wed, 22 Apr 2020 18:31:34 +0200
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork
To:     "Karstens, Nate" <Nate.Karstens@garmin.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Changli Gao <xiaosuo@gmail.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <fa6c5c9c7c434f878c94a7c984cd43ba@garmin.com>
 <20200422154356.GU5820@bombadil.infradead.org>
 <6ed7bd08892b4311b70636658321904f@garmin.com>
From:   Bernd Petrovitsch <bernd@petrovitsch.priv.at>
X-Pep-Version: 2.0
Message-ID: <97f05204-a27c-7cc8-429a-edcf6eebaa11@petrovitsch.priv.at>
Date:   Wed, 22 Apr 2020 16:31:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6ed7bd08892b4311b70636658321904f@garmin.com>
Content-Type: multipart/mixed;
 boundary="------------5C6F5C422D1052E6828086F8"
Content-Language: en-US
X-DCC-INFN-TO-Metrics: esgaroth.tuxoid.at 1233; Body=22 Fuz1=22 Fuz2=22
X-Virus-Scanned: clamav-milter 0.97 at esgaroth.tuxoid.at
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED
        autolearn=unavailable version=3.3.1
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on esgaroth.tuxoid.at
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------5C6F5C422D1052E6828086F8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 22/04/2020 16:02, Karstens, Nate wrote:
>> It's not safe to call system() from a threaded app.  That's all.  It's=
 right there in the DESCRIPTION:
>=20
> That is true, but that description is missing from both the Linux man p=
age and the glibc documentation (https://www.gnu.org/software/libc/manual=
/html_mono/libc.html#Running-a-Command). It seems like a minor point that=
 won't be noticed until it causes a problem, and problems are rare enough=
 they might go unnoticed for a while. We have removed system() from our a=
pplication, but we're also concerned that libraries we integrate will use=
 system() without our knowledge.

Reimplementing system() is trivial.
LD_LIBRARY_PRELOAD should take care of all system(3) calls.

I wonder it it has some value to add runtime checking for
"multi-threaded" to such lib functions and error out if
yes.

Apart from that, system() is a PITA even on
single/non-threaded apps.

MfG,
	Bernd
--=20
There is no cloud, just other people computers.
-- https://static.fsf.org/nosvn/stickers/thereisnocloud.svg

--------------5C6F5C422D1052E6828086F8
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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3D=3D
=3DGX6K
-----END PGP PUBLIC KEY BLOCK-----

--------------5C6F5C422D1052E6828086F8--
