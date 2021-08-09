Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161563E3F30
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 07:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhHIFFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 01:05:55 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:34328 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229516AbhHIFFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 01:05:54 -0400
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 6EF5118036185;
        Mon,  9 Aug 2021 05:05:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 22041D1513;
        Mon,  9 Aug 2021 05:05:32 +0000 (UTC)
Message-ID: <686044636dbf886e7eedb626ca1569e82eac1a64.camel@perches.com>
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
From:   Joe Perches <joe@perches.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Sun, 08 Aug 2021 22:05:30 -0700
In-Reply-To: <b384c564-8467-1504-026c-5a437cad1a14@redhat.com>
References: <cover.1628306392.git.jtoppins@redhat.com>
         <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
         <37c7bbbb01ede99974fc9ce3c3f5dad4845df9ee.camel@perches.com>
         <f519f9eb-aefd-4d0a-01ce-4ed37b7930ef@redhat.com>
         <745ab8a85430ad4268a86b0957aa690c1a7a6d0f.camel@perches.com>
         <b384c564-8467-1504-026c-5a437cad1a14@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 22041D1513
X-Spam-Status: No, score=-1.40
X-Stat-Signature: 7zybqshknhaxu318pnuk4bfxcsikd7e8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18DVtuWEsVOT2+KMyTbl5V/0Ot7rsyBgvs=
X-HE-Tag: 1628485532-223313
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-08-08 at 22:07 -0400, Jonathan Toppins wrote:
> On 8/8/21 6:02 AM, Joe Perches wrote:
> > On Sat, 2021-08-07 at 17:54 -0400, Jonathan Toppins wrote:
> > > On 8/6/21 11:52 PM, Joe Perches wrote:
> > > > On Fri, 2021-08-06 at 23:30 -0400, Jonathan Toppins wrote:
> > > > > There seems to be no reason to have different error messages between
> > > > > netlink and printk. It also cleans up the function slightly.
> > > > []
> > > > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > > []
> > > > > +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> > > > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > > > +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
> > > > > +} while (0)
> > > > > +
> > > > > +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
> > > > > +	NL_SET_ERR_MSG(extack, errmsg);				\
> > > > > +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
> > > > > +} while (0)
> > > > 
> > > > If you are doing this, it's probably smaller object code to use
> > > > 	"%s", errmsg
> > > > as the errmsg string can be reused
> > > > 
> > > > #define BOND_NL_ERR(bond_dev, extack, errmsg)			\
> > > > do {								\
> > > > 	NL_SET_ERR_MSG(extack, errmsg);				\
> > > > 	netdev_err(bond_dev, "Error: %s\n", errmsg);		\
> > > > } while (0)
> > > > 
> > > > #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg)	\
> > > > do {								\
> > > > 	NL_SET_ERR_MSG(extack, errmsg);				\
> > > > 	slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> > > > } while (0)
> > > > 
> > > > 
> > > 
> > > I like the thought and would agree if not for how NL_SET_ERR_MSG is
> > > coded. Unfortunately it does not appear as though doing the above change
> > > actually generates smaller object code. Maybe I have incorrectly
> > > interpreted something?
> > 
> > No, it's because you are compiling allyesconfig or equivalent.
> > Try defconfig with bonding.
> > 
> > 
> 
> $ git clean -dxf
> $ git log -1 -p
> commit 8985f8d3fa38bca5f5384f9210ed735d58fd94f2 (HEAD -> 
> upstream-bonding-cleanup)
> Author: Jonathan Toppins <jtoppins@redhat.com>
> Date:   Sun Aug 8 21:45:14 2021 -0400
> 
>      object code optimization
> 
> diff --git a/drivers/net/bonding/bond_main.c 
> b/drivers/net/bonding/bond_main.c
> index 46b95175690b..e2903ae7cdab 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1714,12 +1714,12 @@ void bond_lower_state_changed(struct slave *slave)
> 
>   #define BOND_NL_ERR(bond_dev, extack, errmsg) do {             \
>          NL_SET_ERR_MSG(extack, errmsg);                         \
> -       netdev_err(bond_dev, "Error: " errmsg "\n");            \
> +       netdev_err(bond_dev, "Error: %s\n", errmsg);            \
>   } while (0)
> 
>   #define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do { \
>          NL_SET_ERR_MSG(extack, errmsg);                         \
> -       slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");  \
> +       slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);  \
>   } while (0)
> 
>   /* enslave device <slave> to bond device <master> */
> $ git log --oneline -2
> 8985f8d3fa38 (HEAD -> upstream-bonding-cleanup) object code optimization
> e326bf8fd30f bonding: combine netlink and console error messages
> $ make defconfig
>    HOSTCC  scripts/basic/fixdep
> [...]
> *** Default configuration is based on 'x86_64_defconfig'
> #
> # configuration written to .config
> #
> $ grep "BONDING" .config
> # CONFIG_BONDING is not set
> $ make menuconfig
>    UPD     scripts/kconfig/mconf-cfg
> [...]
> configuration written to .config
> 
> *** End of the configuration.
> *** Execute 'make' to start the build or try 'make help'.
> 
> $ grep "BONDING" .config
> CONFIG_BONDING=m
> $ git rebase -i --exec "make drivers/net/bonding/bond_main.o; ls -l 
> drivers/net/bonding/bond_main.o" HEAD^^
> Executing: make drivers/net/bonding/bond_main.o; ls -l 
> drivers/net/bonding/bond_main.o
>    SYNC    include/config/auto.conf.cmd
> [...]
>    CC      /home/jtoppins/projects/linux-rhel7/tools/objtool/librbtree.o
>    LD      /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool-in.o
>    LINK    /home/jtoppins/projects/linux-rhel7/tools/objtool/objtool
>    CC [M]  drivers/net/bonding/bond_main.o
> -rw-r--r--. 1 jtoppins jtoppins 131800 Aug  8 21:47 
> drivers/net/bonding/bond_main.o
> Executing: make drivers/net/bonding/bond_main.o; ls -l 
> drivers/net/bonding/bond_main.o
>    CALL    scripts/checksyscalls.sh
>    CALL    scripts/atomic/check-atomics.sh
>    DESCEND objtool
>    CC [M]  drivers/net/bonding/bond_main.o
> -rw-r--r--. 1 jtoppins jtoppins 131928 Aug  8 21:47 

Your size is significantly different than mine (x86-64 defconfig w/ bonding)

$ gcc --version
gcc (Ubuntu 10.3.0-1ubuntu1) 10.3.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Original:

$ git log -1
commit 7999516e20bd9bb5d1f7351cbd05ca529a3a8d60 (HEAD, tag: next-20210806, origin/master, origin/HEAD)
Author: Mark Brown <broonie@kernel.org>
Date:   Fri Aug 6 17:52:53 2021 +0100

    Add linux-next specific files for 20210806
    
    Signed-off-by: Mark Brown <broonie@kernel.org>

$ size drivers/net/bonding/built-in.a -t
   text	   data	    bss	    dec	    hex	filename
  59630	    399	    460	  60489	   ec49	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
  16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
  17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
   7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
   1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
    165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
   6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
  15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
   4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
 129842	   2357	    462	 132661	  20635	(TOTALS)

Then with your 2 patches:

$ size -t drivers/net/bonding/built-in.a
   text	   data	    bss	    dec	    hex	filename
  59590	    399	    460	  60449	   ec21	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
  16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
  17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
   7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
   1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
    165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
   6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
  15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
   4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
 129802	   2357	    462	 132621	  2060d	(TOTALS)

Then with my suggestion:

$ size -t drivers/net/bonding/built-in.a
   text	   data	    bss	    dec	    hex	filename
  59561	    399	    460	  60420	   ec04	drivers/net/bonding/bond_main.o (ex drivers/net/bonding/built-in.a)
  16790	     14	      2	  16806	   41a6	drivers/net/bonding/bond_3ad.o (ex drivers/net/bonding/built-in.a)
  17101	     50	      0	  17151	   42ff	drivers/net/bonding/bond_alb.o (ex drivers/net/bonding/built-in.a)
   7116	   1516	      0	   8632	   21b8	drivers/net/bonding/bond_sysfs.o (ex drivers/net/bonding/built-in.a)
   1411	     72	      0	   1483	    5cb	drivers/net/bonding/bond_sysfs_slave.o (ex drivers/net/bonding/built-in.a)
    165	      0	      0	    165	     a5	drivers/net/bonding/bond_debugfs.o (ex drivers/net/bonding/built-in.a)
   6971	    232	      0	   7203	   1c23	drivers/net/bonding/bond_netlink.o (ex drivers/net/bonding/built-in.a)
  15889	     74	      0	  15963	   3e5b	drivers/net/bonding/bond_options.o (ex drivers/net/bonding/built-in.a)
   4769	      0	      0	   4769	   12a1	drivers/net/bonding/bond_procfs.o (ex drivers/net/bonding/built-in.a)
 129773	   2357	    462	 132592	  205f0	(TOTALS)

cheers, Joe

