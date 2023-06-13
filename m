Return-Path: <netdev+bounces-10389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 911D872E3D5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD10F1C20C73
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B7F2A715;
	Tue, 13 Jun 2023 13:13:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DCF522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:13:56 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C11D1AA;
	Tue, 13 Jun 2023 06:13:52 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q93qE-0000O9-06;
	Tue, 13 Jun 2023 13:13:46 +0000
Date: Tue, 13 Jun 2023 14:13:28 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Qingfang Deng <dqfext@gmail.com>
Subject: Re: [PATCH net-next] net: phy: mediatek-ge-soc: initialize MT7988
 PHY LEDs default state
Message-ID: <ZIhreKECr8nsNgrh@makrotopia.org>
References: <ZIfT7UUzj74NyzL_@makrotopia.org>
 <922466fd-bb14-4b6e-ad40-55b4249c571f@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <922466fd-bb14-4b6e-ad40-55b4249c571f@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

On Tue, Jun 13, 2023 at 05:23:25AM +0200, Andrew Lunn wrote:
> > +/* Registers on MDIO_MMD_VEND2 */
> > +#define MTK_PHY_LED0_ON_CTRL			0x24
> > +#define MTK_PHY_LED1_ON_CTRL			0x26
> > +#define   MTK_PHY_LED_ON_MASK			GENMASK(6, 0)
> > +#define   MTK_PHY_LED_ON_LINK1000		BIT(0)
> > +#define   MTK_PHY_LED_ON_LINK100		BIT(1)
> > +#define   MTK_PHY_LED_ON_LINK10			BIT(2)
> > +#define   MTK_PHY_LED_ON_LINKDOWN		BIT(3)
> > +#define   MTK_PHY_LED_ON_FDX			BIT(4) /* Full duplex */
> > +#define   MTK_PHY_LED_ON_HDX			BIT(5) /* Half duplex */
> > +#define   MTK_PHY_LED_FORCE_ON			BIT(6)
> > +#define   MTK_PHY_LED_POLARITY			BIT(14)
> > +#define   MTK_PHY_LED_ENABLE			BIT(15)
> 
> Would enable being clear result in the LED being off? You can force it
> on with MTK_PHY_LED_FORCE_ON | MTK_PHY_LED_ENABLE? That gives you
> enough to allow software control of the LED. You can then implement
> the led_brightness_set() op, if you want.

Yes, and that would be the next thing I was planning to work on.

> 
> I assume the above are specific to LED0? It would be good to include
> the 0 in the name, to make that clear.

The PHY has two LED outputs, LED0 and LED1. Both have an ON_CTRL and
a BLINK_CTRL register each with identical layouts for LED0_ON_CTRL and
LED1_ON_CTRL as well as LED0_BLINK_CTRL as well as LED1_BLINK_CTRL.

> 
> > +
> > +#define MTK_PHY_LED0_BLINK_CTRL			0x25
> > +#define MTK_PHY_LED1_BLINK_CTRL			0x27
> > +#define   MTK_PHY_LED_1000TX			BIT(0)
> 
> So do this mean LINK1000 + blink on TX ?

Exactly.

> 
> > +#define   MTK_PHY_LED_1000RX			BIT(1)
> 
> So do this mean LINK1000 + blink on RX ?
> 

Yep.

> It would be good to add a comment, because at some point it is likely
> somebody will want to offload the ledtrig-netdev and will need to
> understand what these really do.
> 
> > +#define   MTK_PHY_LED_100TX			BIT(2)
> > +#define   MTK_PHY_LED_100RX			BIT(3)
> > +#define   MTK_PHY_LED_10TX			BIT(4)
> > +#define   MTK_PHY_LED_10RX			BIT(5)
> > +#define   MTK_PHY_LED_COLLISION			BIT(6)
> > +#define   MTK_PHY_LED_RX_CRC_ERR		BIT(7)
> > +#define   MTK_PHY_LED_RX_IDLE_ERR		BIT(8)
> > +#define   MTK_PHY_LED_FORCE_BLINK		BIT(9)
> 
> Is there a way to force the LED1 off/on?  I guess not setting any of
> these bits will force it off.

Both LED0 and LED1 of each PHY can be forced on by writing
MTK_PHY_LED_FORCE_ON | MTK_PHY_LED_ENABLE to MTK_PHY_LEDx_ON_CTRL.
They can be forced off by clearing MTK_PHY_LED_ENABLE in
MTK_PHY_LEDx_ON_CTRL.

Similarly, blinking can be forced by setting MTK_PHY_LED_FORCE_BLINK
in the MTK_PHY_LEDx_BLINK_CTRL register.

> 
> So the polarity and enable bits apply to LED1? 

The LED controller of both LEDs are identical. The SoC's pinmux assigns
LED0 as LED_A, LED_B, LED_C and LED_D respectively. And those pins are
used for bootstrapping board configuration bits, and that then implies
the polarity of the connected LED.

Ie.
-----------------------------+ SoC pin
--------------+-------+      |
       port 0 = PHY 0 - LED0 - LED_A
              +-------\ LED1 - JTAG_JTDI
       port 1 = PHY 1 - LED0 - LED_B
MT7530        +-------\ LED1 - JTAG_JTDO
       port 2 = PHY 2 - LED0 - LED_C
              +-------\ LED1 - JTAG_JTMS
       port 3 = PHY 3 - LED0 - LED_D
--------------+-------\ LED1 - JTAG_JTCLK
       2P5G PHY       - LED0 - LED_E
----------------------\ LED1 - JTAG_JTRST_N
--------------+--------------+

> 
> > +
> >  #define MTK_PHY_RG_BG_RASEL			0x115
> >  #define   MTK_PHY_RG_BG_RASEL_MASK		GENMASK(2, 0)
> >  
> > +/* Register in boottrap syscon defining the initial state of the 4 PHY LEDs */
> 
> Should this be bootstrap? You had the same in the commit message.
> 
> Also, i'm confused. Here you say 4 PHY LEDs, yet
> 
> > +#define MTK_PHY_LED0_ON_CTRL			0x24
> > +#define MTK_PHY_LED1_ON_CTRL			0x26
> 
> suggests there are two LEDs?

There are 4 PHYs with two LEDs each. Only LED0 of each PHY is using
a pin which is used for bootstrapping, hence LED polarity is known
only for those, polarity of LED1 is unknown and always set the default
at this point.

> 
> Should these actually be :
> 
> > +#define MTK_PHY_LED_ON_CTRL1			0x24
> > +#define MTK_PHY_LED_ON_CTRL2			0x26
> 
> meaning each LED has two control registers?

No, each LED has one control register and each PHY has two LEDs, and
there are four PHYs total in the package.

> 
> MTK_PHY_LED_ON_LINK1000 should actually be MTK_PHY_LED_ON_CTRL1_LINK1000 ?

Maybe MTK_PHY_LED_ON_CTRL_LINK1000 would be more appropriate.

> MTK_PHY_LED_100TX should be MTK_PHY_LED_CTRL2_100TX ?

Maybe better MTK_PHY_LED_BLINK_100TX.

> 
> I find it good practice to ensure a bit value #define includes enough
> information in its name to clear indicate what register it applies to.

I agree and will make the names more clear, always using the
MTK_PHY_LED_ON_CTRL_ prefix for bits in the MTK_PHY_LEDx_ON_CTRL
register and MTK_PHY_LED_BLINK_CTRL_ prefix for all registers in
MTK_PHY_LEDx_BLINK_CTRL.

> 
> > +static int mt798x_phy_setup_led(struct phy_device *phydev, bool inverted)
> > +{
> > +	struct pinctrl *pinctrl;
> > +	const u16 led_on_ctrl_defaults = MTK_PHY_LED_ENABLE      |
> > +					 MTK_PHY_LED_ON_LINK1000 |
> > +					 MTK_PHY_LED_ON_LINK100  |
> > +					 MTK_PHY_LED_ON_LINK10;
> > +	const u16 led_blink_defaults = MTK_PHY_LED_1000TX |
> > +				       MTK_PHY_LED_1000RX |
> > +				       MTK_PHY_LED_100TX  |
> > +				       MTK_PHY_LED_100RX  |
> > +				       MTK_PHY_LED_10TX   |
> > +				       MTK_PHY_LED_10RX;
> > +
> > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED0_ON_CTRL,
> > +		      led_on_ctrl_defaults ^
> > +		      (inverted ? MTK_PHY_LED_POLARITY : 0));
> > +
> > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED1_ON_CTRL,
> > +		      led_on_ctrl_defaults);
> > +
> 
> Now i'm even more confused. Both have the same value, expect the
> polarity bit?

Only LED0 polarity of each PHY is affected by the bootstrap pins
LED_A, LED_B, LED_C and LED_D of the SoC, see above.
Hence we need to XOR polarity only for LED0.

> 
> Please add a lot of comments about how this hardware actually works!
> 
> > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED0_BLINK_CTRL,
> > +		      led_blink_defaults);
> > +
> > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED1_BLINK_CTRL,
> > +		      led_blink_defaults);
> > +
> > +	pinctrl = devm_pinctrl_get_select(&phydev->mdio.dev, "gbe-led");
> 
> This is also very unusual. At minimum, it needs a comment as to why it
> is needed. But more likely, because no other driver in driver/net does
> this, it makes me think it is wrong.

The reason for not using the "default" pinctrl name is simply that then
the "default" state will already be requested by device model *before*
the LED registers are actually setup. This results in a short but unwanted
blink of the LEDs during setup.
Requesting the pinctrl state only once the setup is done allows avoiding
that, but of course this is of purely aesthetic nature.

> 
> > +static bool mt7988_phy_get_boottrap_polarity(struct phy_device *phydev)
> > +{
> > +	struct mtk_socphy_shared *priv = phydev->shared->priv;
> > +
> > +	if (priv->boottrap & BIT(phydev->mdio.addr))
> > +		return false;
> 
> This can be simplified to
> 
> 	return !priv->boottrap & BIT(phydev->mdio.addr);

Ack.


> 
> 	Andrew

