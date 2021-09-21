Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DED4139E1
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 20:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhIUSSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 14:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhIUSSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 14:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FBB860F48;
        Tue, 21 Sep 2021 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632248199;
        bh=CZ1jS1fbgx8mv8FGFJWF9Qe/+BOAki1/dRRl8GRTDK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j21R1nTKkra6hmoia4Sro3lz8h1arqw2MZ96VJMvTmsrtDmn1lATQSqRhny78o3Zu
         al75kpmnfzZb8jQcuvJDvZ0TSffZVZ96Zr/afkV09QBWFJDvbLpSPW+9W/JE/19WP7
         LbcCTDCUztM/Et5ZZQJ2wv9hNZXionyyU9cemI1tnkltKkUJnPtMI3S+T5bcTYQPFM
         51XB3fsFHaxpSUiFSDUbF9+pd71YfzoBPnlOcnfPwHcJ2mojR7o/n1EJIVcaw+58/f
         vps8ew1TUPKDLUzE0wkYOqzQQNnW8uUzPOlmZDF5sNf1qreauEtGNTexdr+ArkqOYz
         sZft78ubw3thg==
Date:   Tue, 21 Sep 2021 20:16:33 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Tony Luck <tony.luck@intel.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] get_abi.pl: Check for missing symbols at the ABI
 specs
Message-ID: <20210921201633.5e6128a0@coco.lan>
In-Reply-To: <YUoN2m/OYHVLPrSl@kroah.com>
References: <cover.1631957565.git.mchehab+huawei@kernel.org>
        <YUoN2m/OYHVLPrSl@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 21 Sep 2021 18:52:42 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Sat, Sep 18, 2021 at 11:52:10AM +0200, Mauro Carvalho Chehab wrote:
> > Hi Greg,
> >=20
> > Add a new feature at get_abi.pl to optionally check for existing symbols
> > under /sys that won't match a "What:" inside Documentation/ABI.
> >=20
> > Such feature is very useful to detect missing documentation for ABI.
> >=20
> > This series brings a major speedup, plus it fixes a few border cases wh=
en
> > matching regexes that end with a ".*" or \d+.
> >=20
> > patch 1 changes get_abi.pl logic to handle multiple What: lines, in
> > order to make the script more robust;
> >=20
> > patch 2 adds the basic logic. It runs really quicky (up to 2
> > seconds), but it doesn't use sysfs softlinks.
> >=20
> > Patch 3 adds support for parsing softlinks. It makes the script a
> > lot slower, making it take a couple of minutes to process the entire
> > sysfs files. It could be optimized in the future by using a graph,
> > but, for now, let's keep it simple.
> >=20
> > Patch 4 adds an optional parameter to allow filtering the results
> > using a regex given by the user. When this parameter is used
> > (which should be the normal usecase), it will only try to find softlinks
> > if the sysfs node matches a regex.
> >=20
> > Patch 5 improves the report by avoiding it to ignore What: that
> > ends with a wildcard.
> >=20
> > Patch 6 is a minor speedup.  On a Dell Precision 5820, after patch 6,=20
> > results are:
> >=20
> > 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefine=
d| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr=
 >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> >=20
> > 	real	2m35.563s
> > 	user	2m34.346s
> > 	sys	0m1.220s
> > 	7595 undefined
> > 	896 undefined_symbols
> >=20
> > Patch 7 makes a *huge* speedup: it basically switches a linear O(n^3)
> > search for links by a logic which handle symlinks using BFS. It
> > also addresses a border case that was making 'msi-irqs/\d+' regex to
> > be misparsed.=20
> >=20
> > After patch 7, it is 11 times faster:
> >=20
> > 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefine=
d| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr=
 >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> >=20
> > 	real	0m14.137s
> > 	user	0m12.795s
> > 	sys	0m1.348s
> > 	7030 undefined
> > 	794 undefined_symbols
> >=20
> > (the difference on the number of undefined symbols are due to the fix f=
or
> > it to properly handle 'msi-irqs/\d+' regex)
> >=20
> > -
> >=20
> > While this series is independent from Documentation/ABI changes, it
> > works best when applied from this tree, which also contain ABI fixes
> > and a couple of additions of frequent missed symbols on my machine:
> >=20
> >     https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/l=
og/?h=3Dget_undefined_abi_v3 =20
>=20
> I've taken all of these, but get_abi.pl seems to be stuck in an endless
> loop or something.  I gave up and stopped it after 14 minutes.  It had
> stopped printing out anything after finding all of the pci attributes
> that are not documented :)

It is probably not an endless loop, just there are too many vars to
check on your system, which could make it really slow.

The way the search algorithm works is that reduces the number of regex=20
expressions that will be checked for a given file entry at sysfs. It=20
does that by looking at the devnode name. For instance, when it checks for
this file:

	/sys/bus/pci/drivers/iosf_mbi_pci/bind

The logic will seek only the "What:" expressions that end with "bind".
Currently, there are just two What expressions for it[1]:

	What: /sys/bus/fsl\-mc/drivers/.*/bind
	What: /sys/bus/pci/drivers/.*/bind

It will then run an O(n=C2=B2) algorithm to seek:

		foreach my $a (@names) {
                       foreach my $w (split /\xac/, $what) {
                               if ($a =3D~ m#^$w$#) {
					exact =3D 1;
                                        last;
                                }
			}
		}

Which runs quickly, when there are few regexs to seek. There are,=20
however, some What: expressions that end with a wildcard. Those are
harder to process. Right now, they're all grouped together, which
makes them slower. Most of the processing time are spent on those.

I'm working right now on some strategy to also speed up the search=20
for them. Once I get something better, I'll send a patch series.

--

[1] On a side note, there are currently some problems with the What:
    definitions for bind/unbind, as:

	- it doesn't match all PCI devices;
	- it doesn't match ACPI and other buses that also export
	  bind/unbind.

>=20
> Anything I can do to help debug this?
>

There are two parameters that can help to identify the issue:

a) You can add a "--show-hints" parameter. This turns on some=20
   prints that may help to identify what the script is doing.
   It is not really a debug option, but it helps to identify
   when some regexes are failing.

b) You can limit the What expressions that will be parsed with:
	   --search-string <something>

You can combine both. For instance, if you want to make it
a lot more verbose, you could run it as:

	./scripts/get_abi.pl undefined --search-string /sys --show-hints

The script will then print all regexes that will be checked, and when
actually checking for the missing vars, it will print all names for
a given entry at sysfs.

So, if you want to know how an i2c bind has been validated, you
could do:

	$ ./scripts/get_abi.pl undefined --search-string i2c/.*/bind --show-hints
	--> /sys/bus/i2c/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
dummy/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/driver/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/driver/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/dummy/bi=
nd
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/dummy/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/dummy/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/axp20x-i2=
c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/axp20x-i2=
c/bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/axp20x-i=
2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/axp20x-i2c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/axp20x-i2=
c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/axp20x-i2c/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/smbus_ale=
rt/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/smbus_ale=
rt/bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/smbus_al=
ert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/smbus_alert/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/smbus_ale=
rt/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/smbus_alert/bind
	--> /sys/module/i2c_smbus/drivers/i2c:smbus_alert/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/ee1004/bind
	--> /sys/module/ee1004/drivers/i2c:ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/ee1004/bi=
nd
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/ee1004/bi=
nd
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/ee1004/b=
ind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/ee1004/bi=
nd
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/ee1004/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/driver/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/intel_soc=
_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/intel_soc=
_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/intel_so=
c_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/intel_soc_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/intel_soc=
_pmic_i2c/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/intel_soc_pmic_i2c/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/tps68470/=
bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/tps68470/=
bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/tps68470=
/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/tps68470/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/tps68470/=
bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/tps68470/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind
	--> /sys/bus/i2c/drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-3=
/i2c-14/subsystem/drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-4=
/i2c-15/subsystem/drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0036/subsystem/drivers/=
CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2=
/i2c-13/subsystem/drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0050/subsystem/drivers/=
CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-10/subsystem/dri=
vers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-5/subsystem/drivers/CHT Whisk=
ey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-3/subsystem/drivers/CHT Whisk=
ey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-1/subsystem/=
drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1=
/i2c-12/subsystem/drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/16-0037/subsystem/drivers/=
CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-8/subsystem/driv=
ers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-9/subsystem/driv=
ers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-2/subsystem/=
drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/subsystem/=
drivers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:1f.4/i2c-16/subsystem/drivers/CHT Whis=
key Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-7/subsystem/driv=
ers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-6/subsystem/driv=
ers/CHT Whiskey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/CHT Whisk=
ey Cove PMIC/bind
	--> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/i2c-11/subsystem/dri=
vers/CHT Whiskey Cove PMIC/bind
	    more likely regexes:
		/sys/bus/fsl\-mc/drivers/.*/bind
		/sys/bus/pci/drivers/.*/bind

Btw, on the above example, I have already a patch addressing it
(see enclosed). I intend to submit it on a newer patch series.

Thanks,
Mauro

[PATCH] ABI: sysfs-bus-pci: add a alternative What fields

There are some PCI ABI that aren't shown under:

	/sys/bus/pci/drivers/.../

Because they're registered with a different class. That's
the case of, for instance:

	/sys/bus/i2c/drivers/CHT Whiskey Cove PMIC/unbind

This one is not present under /sys/bus/pci:

	$ find /sys/bus/pci -name 'CHT Whiskey Cove PMIC'

Although clearly this is provided by a PCI driver:

	/sys/devices/pci0000:00/0000:00:02.0/i2c-4/subsystem/drivers/CHT Whiskey C=
ove PMIC/unbind

So, add an altertate What location in order to match bind/unbind
to such devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/te=
sting/sysfs-bus-pci
index 1da4c8db3a9e..f4efbcb0b18c 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -1,4 +1,5 @@
 What:		/sys/bus/pci/drivers/.../bind
+What:		/sys/devices/pciX/.../bind
 Date:		December 2003
 Contact:	linux-pci@vger.kernel.org
 Description:
@@ -14,6 +15,7 @@ Description:
 		(Note: kernels before 2.6.28 may require echo -n).
=20
 What:		/sys/bus/pci/drivers/.../unbind
+What:		/sys/devices/pciX/.../unbind
 Date:		December 2003
 Contact:	linux-pci@vger.kernel.org
 Description:
@@ -29,6 +31,7 @@ Description:
 		(Note: kernels before 2.6.28 may require echo -n).
=20
 What:		/sys/bus/pci/drivers/.../new_id
+What:		/sys/devices/pciX/.../new_id
 Date:		December 2003
 Contact:	linux-pci@vger.kernel.org
 Description:
@@ -47,6 +50,7 @@ Description:
 		  # echo "8086 10f5" > /sys/bus/pci/drivers/foo/new_id
=20
 What:		/sys/bus/pci/drivers/.../remove_id
+What:		/sys/devices/pciX/.../remove_id
 Date:		February 2009
 Contact:	Chris Wright <chrisw@sous-sol.org>
 Description:


