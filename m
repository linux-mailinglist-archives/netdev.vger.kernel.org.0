Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F0479FE4
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 09:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbhLSIbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 03:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhLSIbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 03:31:07 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4427AC061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 00:31:07 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1myrav-0002Qa-Uo; Sun, 19 Dec 2021 09:31:02 +0100
Message-ID: <edb8c052-9d20-d190-54e2-ed9bb03ba204@leemhuis.info>
Date:   Sun, 19 Dec 2021 09:31:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
Content-Language: en-BW
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639902667;10240f3d;
X-HE-SMSGID: 1myrav-0002Qa-Uo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 29.11.21 22:14, Heiner Kallweit wrote:
> Recent net core changes caused an issue with few Intel drivers
> (reportedly igb), where taking RTNL in RPM resume path results in a
> deadlock. See [0] for a bug report. I don't think the core changes
> are wrong, but taking RTNL in RPM resume path isn't needed.
> The Intel drivers are the only ones doing this. See [1] for a
> discussion on the issue. Following patch changes the RPM resume path
> to not take RTNL.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=215129
> [1] https://lore.kernel.org/netdev/20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/t/
> 
> Fixes: bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open")
> Fixes: f32a21376573 ("ethtool: runtime-resume netdev parent before ethtool ioctl ops")
> Tested-by: Martin Stolpe <martin.stolpe@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Long story short: what is taken this fix so long to get mainlined? It to
me seems progressing unnecessary slow, especially as it's a regression
that made it into v5.15 and thus for weeks now seems to bug more and
more people.


The long story, starting with the background details:

The quoted patch fixes a regression among others caused by f32a21376573
("ethtool: runtime-resume netdev parent before ethtool ioctl ops"),
which got merged for v5.15-rc1.

The regression ("kernel hangs during power down") was afaik first
reported on Wed, 24 Nov (IOW: nearly a month ago) and forwarded to the
list shortly afterwards:
https://bugzilla.kernel.org/show_bug.cgi?id=215129
https://lore.kernel.org/netdev/20211124144505.31e15716@hermes.local/

The quoted patch to fix the regression was posted on Mon, 29 Nov (thx
Heiner for providing it!). Obviously reviewing patches can take a few
days when they are complicated, as the other messages in this thread
show. But according to
https://bugzilla.kernel.org/show_bug.cgi?id=215129#c8 the patch was
ACKed by Thu, 7 Dec. To quote: ```The patch is on its way via the Intel
network driver tree:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/tnguy/net-queue/+/refs/heads/dev-queue```

And that's where the patch afaics still is. It hasn't even reached
linux-next yet, unless I'm missing something. A merge into mainline thus
is not even in sight; this seems especially bad with the holiday season
coming up, as getting the fix mainlined is a prerequisite to get it
backported to 5.15.y, as our latest stable kernel is affected by this.

Due to the slow progress we have other users that stumble about the
regression and have to deal with it; some of them even track it down and
report it again. This happened yesterday (and made me write this mail):
https://bugzilla.kernel.org/show_bug.cgi?id=215359


Given the "no regression" rule all this to me looks a lot like 'this is
taken way to long without an obvious reason", as the goal of the rule
round about is: "People should basically always feel like they can
update their kernel and simply not have to worry about it." (Linus wrote
that in
https://lore.kernel.org/lkml/CA+55aFxW7NMAMvYhkvz1UPbUTUJewRt6Yb51QAx5RtrWOwjebg@mail.gmail.com/
). But here we still let them run into a issue known for weeks now;
everyone additionally hit due to unnecessary delays will thus be one
more person that next time will worry when updating, which the "no
regression" rule tries to prevent. :-/


BTW: this is not the only regression in the network subsystem where
regression fixes IMHO linger quite long in some tree below net. Here is
another recent example:
https://lore.kernel.org/linux-wireless/87y24on9m2.fsf@tynnyri.adurom.net/
Fortunately that fix got mainlined last week, after the fix sat in next
for two and a half weeks.

Ciao, Thorsten

P.S.: for completeness: f32a21376573 causes a similar regression ("When
attempting to rise or shut down a NIC manually or via network-manager
under 5.15, the machine reboots or freezes.") in a different driver for
Intel NICs, which is fixed by this patch:
https://lore.kernel.org/netdev/20211214003949.666642-1-vinicius.gomes@intel.com/
It's not that old yet, but also sitting in the dev-queue of the intel
network driver developers and hasn't reached linux-next yet :-/

>  drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index dd208930f..8073cce73 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -9254,7 +9254,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
>  	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
>  }
>  
> -static int __maybe_unused igb_resume(struct device *dev)
> +static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct net_device *netdev = pci_get_drvdata(pdev);
> @@ -9297,17 +9297,24 @@ static int __maybe_unused igb_resume(struct device *dev)
>  
>  	wr32(E1000_WUS, ~0);
>  
> -	rtnl_lock();
> +	if (!rpm)
> +		rtnl_lock();
>  	if (!err && netif_running(netdev))
>  		err = __igb_open(netdev, true);
>  
>  	if (!err)
>  		netif_device_attach(netdev);
> -	rtnl_unlock();
> +	if (!rpm)
> +		rtnl_unlock();
>  
>  	return err;
>  }
>  
> +static int __maybe_unused igb_resume(struct device *dev)
> +{
> +	return __igb_resume(dev, false);
> +}
> +
>  static int __maybe_unused igb_runtime_idle(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
> @@ -9326,7 +9333,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
>  
>  static int __maybe_unused igb_runtime_resume(struct device *dev)
>  {
> -	return igb_resume(dev);
> +	return __igb_resume(dev, true);
>  }
>  
>  static void igb_shutdown(struct pci_dev *pdev)
> @@ -9442,7 +9449,7 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
>   *  @pdev: Pointer to PCI device
>   *
>   *  Restart the card from scratch, as if from a cold-boot. Implementation
> - *  resembles the first-half of the igb_resume routine.
> + *  resembles the first-half of the __igb_resume routine.
>   **/
>  static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
>  {
> @@ -9482,7 +9489,7 @@ static pci_ers_result_t igb_io_slot_reset(struct pci_dev *pdev)
>   *
>   *  This callback is called when the error recovery driver tells us that
>   *  its OK to resume normal operation. Implementation resembles the
> - *  second-half of the igb_resume routine.
> + *  second-half of the __igb_resume routine.
>   */
>  static void igb_io_resume(struct pci_dev *pdev)
>  {

